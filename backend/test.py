import os
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
# from flask_sqlalchemy import SQLAlchemy
from flask_socketio import SocketIO, emit
from database import app, db, Teacher, Course, Lecture

# CORS(app)
app = Flask(__name__)
socketio = SocketIO(app)

# Base directory where the script is located
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Directories for uploads and data, now relative to the script's location
app.config['AUDIO_FOLDER'] = os.path.join(BASE_DIR, 'audio')


@socketio.on('connect')
def test_connect(auth):
    emit('my response', {'data': 'Connected'})
    print('Client connected')


@socketio.on('disconnect')
def test_disconnect():
    print('Client disconnected')


if __name__ == '__main__':
    socketio.run(app)
