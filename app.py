# from flask_mysqldb import MySQL
# from flask import Flask, render_template, request, redirect, url_for, session
# from werkzeug.security import generate_password_hash, check_password_hash

import os
import json
import PyPDF2
import requests

from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
from werkzeug.utils import secure_filename
from datetime import datetime
from dotenv import load_dotenv
from werkzeug.security import generate_password_hash, check_password_hash
from collections import Counter

load_dotenv()
app = Flask(__name__)
app.secret_key = "Ambatukam_secret_key"

# ------------------- Database Configuration -------------------
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'hirelytic'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

# app.config['DROPZONE_ALLOWED_FILE_TYPE'] = 'document'
# app.config['DROPZONE_MAX_FILE_SIZE'] = 10
# Configure Upload Folder
UPLOAD_FOLDER = 'static/uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
# --------------------------------------------------------------


OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
if not OPENROUTER_API_KEY:
    raise ValueError("OPENROUTER_API_KEY not found in environment variables")
# ------------------- Llama AI Configuration -------------------

print("OpenRouter API key loaded:", bool(OPENROUTER_API_KEY))


def analyze_resume_llama(text, job):
    url = "https://openrouter.ai/api/v1/chat/completions"

    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "meta-llama/llama-3.3-70b-instruct:free",
        "messages": [
            {
                "role": "system",
                "content": "You are an HR assistant that evaluates resumes against a specific job requirement."
            },
            {
                "role": "user",
                "content": f"""
Job Title: {job['job_title']}
Job Description: {job['job_description']}
Required Skills: {job['required_skills']}
Required Education: {job['educational_requirement']}
Minimum Experience: {job['experience_requirement']} years

Resume:
{text}

Return STRICT JSON:
{{
  "education_level": "",
  "years_experience": number,
  "skills": [],
  "matched_skills": [],
  "compatibility_score": number,
  "summary": ""
}}
"""
            }
        ]
    }

    response = requests.post(url, headers=headers, json=payload)
    response.raise_for_status()

    return response.json()["choices"][0]["message"]["content"]

# ---------------------- ROUTES ----------------------


@app.route('/')
def home():
    return render_template('homepage.html')


@app.route('/signinform')
def signinform():
    return render_template('SignIn.html')


@app.route('/signin', methods=['GET', 'POST'])
def signin():
    if request.method == "POST":
        cur = mysql.connection.cursor()
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')

        if not username or not password:
            return "Username and password cannot be empty", 400

        # Check if user already exists
        cur.execute("SELECT * FROM users WHERE userName=%s", (username,))
        if cur.fetchone():
            return "Username already exists", 400

        # Hash the password before saving
        hashed_password = generate_password_hash(password)

        sql = "INSERT INTO users (userName, email, passwordHash) VALUES (%s, %s, %s)"
        cur.execute(sql, (username, email, hashed_password))
        mysql.connection.commit()
        user_id = cur.lastrowid
        cur.close()

        session['username'] = username
        session['user_id'] = user_id
        return render_template('dashboard.html', username=username)

    else:
        username = session.get('username')
        if username:
            return render_template('dashboard.html', username=username)

    return render_template('dashboard.html')


@app.route('/signout')
def signout():
    session.pop('username', None)
    return redirect(url_for('home'))


@app.route('/loginform')
def loginform():
    return render_template('Login.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == "POST":
        identifier = request.form.get('username-email')  # username or email
        password = request.form.get('password')

        # Debugging: print login attempts
        print("Login attempt:", identifier, password)

        cur = mysql.connection.cursor()
        cur.execute(
            "SELECT * FROM users WHERE userName=%s OR email=%s", (
                identifier, identifier)
        )
        user = cur.fetchone()
        cur.close()

        if user and check_password_hash(user['passwordHash'], password):
            session['username'] = user['userName']
            session['user_id'] = user['UserID']
            return redirect(url_for('dashboard'))
        else:
            # Pass error message and entered identifier back to template
            return render_template('Login.html', error="Invalid username/email or password", identifier=identifier)

    # GET request
    return render_template('Login.html')

# Dashboard Route ==========================


@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('loginform'))

    # Get dates from filter
    start_date_raw = request.args.get('start_date', '')
    end_date_raw = request.args.get('end_date', '')

    # Convert "YYYY-MM-DD" to "YYYYMMDD" integer to match your SQL schema
    start_filter = start_date_raw.replace(
        '-', '') if start_date_raw else '20000101'
    end_filter = end_date_raw.replace('-', '') if end_date_raw else '20991231'

    cur = mysql.connection.cursor()
    user_id = session['user_id']
    date_filter = "AND u.analysisDate BETWEEN %s AND %s"

    # 1. Total Resumes
    cur.execute(f"""
        SELECT COUNT(c.candidateID) as total 
        FROM candidates c 
        JOIN uploads u ON c.uploadID = u.uploadID 
        WHERE u.userID = %s {date_filter}
    """, (user_id, start_filter, end_filter))
    total_resumes = cur.fetchone()['total'] or 0

    # 2. Skill Distribution
    cur.execute(f"""
        SELECT cs.skillName, COUNT(*) as count 
        FROM candidate_skills cs 
        JOIN candidates c ON cs.candidateID = c.candidateID 
        JOIN uploads u ON c.uploadID = u.uploadID
        WHERE u.userID = %s {date_filter}
        GROUP BY cs.skillName ORDER BY count DESC LIMIT 6
    """, (user_id, start_filter, end_filter))
    skills_data = cur.fetchall()

    # 3. Dynamic KPIs (Avg Match & Top Talent)
    cur.execute(f"""
        SELECT AVG(c.compatibilityScore) as avg_score 
        FROM candidates c 
        JOIN uploads u ON c.uploadID = u.uploadID 
        WHERE u.userID = %s {date_filter}
    """, (user_id, start_filter, end_filter))
    avg_match = round(cur.fetchone()['avg_score'] or 0)

    cur.execute(f"""
        SELECT COUNT(*) as top_count 
        FROM candidates c 
        JOIN uploads u ON c.uploadID = u.uploadID 
        WHERE u.userID = %s AND c.compatibilityScore >= 80 {date_filter}
    """, (user_id, start_filter, end_filter))
    top_talent = cur.fetchone()['top_count'] or 0

    # 4. Score Distribution for Doughnut Chart
    cur.execute(f"""
        SELECT 
            SUM(CASE WHEN compatibilityScore >= 80 THEN 1 ELSE 0 END) as High,
            SUM(CASE WHEN compatibilityScore >= 50 AND compatibilityScore < 80 THEN 1 ELSE 0 END) as Medium,
            SUM(CASE WHEN compatibilityScore < 50 THEN 1 ELSE 0 END) as Low
        FROM candidates c 
        JOIN uploads u ON c.uploadID = u.uploadID 
        WHERE u.userID = %s {date_filter}
    """, (user_id, start_filter, end_filter))
    score_data = cur.fetchone()
    score_dist = [score_data['High'] or 0,
                  score_data['Medium'] or 0, score_data['Low'] or 0]

    has_analytics = total_resumes > 0
    return render_template('dashboard.html',
                           username=session['username'],
                           has_analytics=has_analytics,
                           total_resumes=total_resumes,
                           avg_match=avg_match,
                           top_talent=top_talent,
                           skills_data=skills_data,
                           score_dist=score_dist,
                           start_date=start_date_raw,
                           end_date=end_date_raw)
#   Upload Form Route ========================


@app.route('/upload_form')
def upload_form():
    username = session.get('username')
    return render_template('upload.html', username=username)


# A.I Analysis Route ===========================
@app.route('/analyze', methods=['POST'])
def analyze():
    if 'user_id' not in session:
        return redirect(url_for('loginform'))

    files = request.files.getlist('resumes')
    if not files or files[0].filename == '':
        flash("No files selected")
        return redirect(url_for('upload_form'))

    cur = mysql.connection.cursor()

    # Create upload batch
    job = {
        "job_title": request.form.get("job_title"),
        "job_description": request.form.get("job_description"),
        "required_skills": request.form.get("required_skills"),
        "educational_requirement": request.form.get("educational_requirement"),
        "experience_requirement": request.form.get("experience_requirement")
    }

    cur.execute("""
        INSERT INTO uploads
        (userID, jobTitle, requiredSkills, educationalRequirement, experienceRequirement, uploadDate)
        VALUES (%s,%s,%s,%s,%s,NOW())
    """, (
        session['user_id'],
        job["job_title"],
        job["required_skills"],
        job["educational_requirement"],
        job["experience_requirement"]
    ))

    mysql.connection.commit()
    upload_id = cur.lastrowid

    start_time = datetime.now()

    for file in files:
        if not file.filename.lower().endswith('.pdf'):
            continue

        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)

        # Extract PDF text
        text = ""
        with open(filepath, 'rb') as pdf:
            reader = PyPDF2.PdfReader(pdf)
            for page in reader.pages:
                text += page.extract_text() or ""

        # AI analysis
        try:
            ai_response = analyze_resume_llama(text, job)

            json_start = ai_response.find("{")
            json_end = ai_response.rfind("}") + 1
            clean_json = ai_response[json_start:json_end]

            data = json.loads(clean_json)

        except Exception as e:
            print("AI parsing error:", e)
            continue

        # Store candidate
        cur.execute("""
            INSERT INTO candidates
            (uploadID, fileName, educationLevel, yearsExperience, compatibilityScore, analysisText)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            upload_id,
            filename,
            data["education_level"],
            data["years_experience"],
            data["compatibility_score"],
            data["summary"]
        ))
        candidate_id = cur.lastrowid

        # Store skills
        for skill in data["skills"]:
            cur.execute("""
                INSERT INTO candidate_skills (candidateID, skillName)
                VALUES (%s, %s)
            """, (candidate_id, skill))

        mysql.connection.commit()

        # Update processing time & analysis date in uploads
        processing_time = int((datetime.now() - start_time).total_seconds())
        cur.execute("""
            UPDATE uploads
            SET processingTime = %s,
                analysisDate = CURDATE()
            WHERE uploadID = %s
        """, (processing_time, upload_id))

        mysql.connection.commit()

    cur.close()

    return redirect(url_for('results', upload_id=upload_id))


# Results Route ==============================
@app.route('/results/<int:upload_id>')
def results(upload_id):
    if 'user_id' not in session:
        return redirect(url_for('loginform'))

    cur = mysql.connection.cursor()

    # Fetch upload info (summary metrics)
    cur.execute("""
        SELECT *
        FROM uploads
        WHERE uploadID = %s AND userID = %s
    """, (upload_id, session['user_id']))
    upload = cur.fetchone()

    if not upload:
        cur.close()
        flash("Upload not found or access denied")
        return redirect(url_for('dashboard'))

    # Fetch analyzed candidates
    cur.execute("""
        SELECT *
        FROM candidates
        WHERE uploadID = %s
        ORDER BY compatibilityScore DESC
    """, (upload_id,))
    candidates = cur.fetchall()

    education_counts = Counter(
        c["educationLevel"] or "Unknown" for c in candidates
    )

    education_labels = list(education_counts.keys())
    education_values = list(education_counts.values())

    # Get top matched skill for this upload
    cur.execute("""
        SELECT cs.skillName, COUNT(*) AS cnt
        FROM candidate_skills cs
        JOIN candidates c ON cs.candidateID = c.candidateID
        WHERE c.uploadID = %s
        GROUP BY cs.skillName
        ORDER BY cnt DESC
        LIMIT 1
    """, (upload_id,))

    top_skill_row = cur.fetchone()
    top_skill = top_skill_row['skillName'] if top_skill_row else "N/A"

    cur.close()

    return render_template(
        'results.html',
        upload=upload,
        candidates=candidates,
        processing_time=upload['processingTime'],
        top_skill=top_skill,
        education_labels=education_labels,
        education_values=education_values
    )


# ----------------------- END ROUTES ----------------------
if __name__ == '__main__':
    app.run(debug=True)
