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


def analyze_resume_llama(text):
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
                "content": "You are an HR assistant that analyzes resumes."
            },
            {
                "role": "user",
                "content": f"""
Analyze the resume and return ONLY valid JSON in this format:
{{
    "education_level": "Bachelor",
    "years_experience": 3,
    "skills": ["Python", "SQL", "Flask"],
    "compatibility_score": 82,
    "summary": "Short summary here"
}}


Resume:
{text}
"""
            }
        ]
    }

    response = requests.post(url, headers=headers, json=payload)
    response.raise_for_status()

    return response.json()["choices"][0]["message"]["content"]


# # ------------------- Gemini AI Configuration -------------------
# # Load the key securely from the environment
# GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

# if not GEMINI_API_KEY:
#     # This will prevent the app from starting if the key is missing
#     raise ValueError(
#         "GEMINI_API_KEY not found. Please create a .env file and add your key."
#     )


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


@app.route('/dashboard')
def dashboard():
    username = session.get('username')
    if username:
        return render_template('dashboard.html', username=username)
    else:
        print(f"User not found")
        return redirect(url_for('loginform'))


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
    cur.execute(
        "INSERT INTO uploads (userID, uploadDate) VALUES (%s, NOW())",
        (session['user_id'],)
    )
    mysql.connection.commit()
    upload_id = cur.lastrowid

    for file in files:
        if file and file.filename.lower().endswith('.pdf'):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)

            #  Extract PDF text
            text = ""
            with open(filepath, 'rb') as pdf_file:
                reader = PyPDF2.PdfReader(pdf_file)
                for page in reader.pages:
                    text += page.extract_text() or ""

            # AI analysis
            analysis_text = analyze_resume_llama(text)

            try:
                data = json.loads(analysis_text)
            except:
                continue  # skip bad AI response

            # Store candidate result
            cur.execute("""
                INSERT INTO candidates
                (uploadID, fileName, analysisText)
                VALUES (%s, %s, %s)
            """, (upload_id, filename, analysis_text))
            mysql.connection.commit()

    cur.close()

    #  Redirect instead of render
    return redirect(url_for('results', upload_id=upload_id))


# ----------------------- END ROUTES ----------------------
if __name__ == '__main__':
    app.run(debug=True)
