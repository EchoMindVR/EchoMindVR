from flask_sqlalchemy import SQLAlchemy
from flask import Flask

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///teachers.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Teacher(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, unique=True, nullable=False)
    audio_path = db.Column(db.String, nullable=False)

    def __repr__(self):
        return f'<Teacher {self.name}>'

class Course(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), unique=True, nullable=False)
    teacher_name = db.Column(db.String(120), nullable=False)
    cover_path = db.Column(db.String(120), nullable=False)
    lectures = db.relationship('Lecture', backref='course', lazy=True)

class Lecture(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    course_id = db.Column(db.Integer, db.ForeignKey('course.id'), nullable=False)
    summary_notes_path = db.Column(db.String(120), nullable=False)
    context = db.Column(db.Text, nullable=False)