# from flask_mysqldb import MySQL
# from flask import Flask, render_template, request, redirect, url_for, session
# from werkzeug.security import generate_password_hash, check_password_hash

import os
import json
import PyPDF2
import google.generativeai as genai
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

# ------------------- Gemini AI Configuration -------------------
# Load the key securely from the environment
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    # This will prevent the app from starting if the key is missing
    raise ValueError(
        "GEMINI_API_KEY not found. Please create a .env file and add your key."
    )

genai.configure(api_key=GEMINI_API_KEY)
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
        cur.close()

        session['username'] = username
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


@app.route('/analyze', methods=['POST', 'GET'])
def analyze():
    pass


# ----------------------- END ROUTES ----------------------
if __name__ == '__main__':
    app.run(debug=True)
