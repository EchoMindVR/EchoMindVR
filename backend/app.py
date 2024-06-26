import os
from flask import request, jsonify
from werkzeug.utils import secure_filename
from database import app, db, Teacher, Course, Lecture, Student, Enrollment
from llm.chat_agent import ChatAgent
from llm.pdf_split import load_pdfs_into_chroma_db

# CORS(app)
from audio.tts import TTS
# Base directory where the script is located
BASE_DIR = os.path.dirname(__file__)

# Directories for uploads and data, now relative to the script's location
app.config['AUDIO_FOLDER'] = os.path.join(BASE_DIR, 'audio/audio_resources')

load_pdfs_into_chroma_db()
@app.route('/')
def test_connection():
    return jsonify({'message': 'API is up and running!'}), 200

@app.route('/teacher/create', methods=['POST'])
def create_teacher():
    data = request.get_json()
    name = data['name']
    password = data['password']
    if name == '' or password == '':
        return jsonify({'message':'ERROR OCCUR!'}), 404
    teacher = Teacher.query.filter_by(name=name).first()
    if teacher is not None:
        return jsonify({'message': f'User {name} is already created'}), 409

    teacher = Teacher(name=name, password=password)
    db.session.add(teacher)
    return jsonify({'message': f'Teacher {name} created/updated successfully'}), 201


@app.route('/teacher/signup', methods=['POST'])
def signup_teacher():
    data = request.get_json()
    name = data['name']
    password = data['password']
    if name == '' or password == '':
        return jsonify({'message':'ERROR OCCUR!'}), 404

    # Check if a teacher with the given name already exists
    existing_teacher = Teacher.query.filter_by(name=name).first()
    if existing_teacher is not None:
        return jsonify({'message': f'Teacher with name {name} already exists'}), 409

    # Create a new teacher and add it to the database
    new_teacher = Teacher(name=name, password=password)
    db.session.add(new_teacher)
    db.session.commit()

    return jsonify({'message': f'Teacher {name} signed up successfully'}), 201


@app.route('/teacher/login', methods=['POST'])
def login_teacher():
    data = request.get_json()
    name = data['name']
    password = data['password']
    if name == '' or password == '':
        return jsonify({'message': 'ERROR OCCUR!'}), 404
    teacher = Teacher.query.filter_by(name=name).first()
    if teacher is not None and teacher.password == password:
        return jsonify({'message': f'Teacher {name} log in successful'}), 201
    else:
        return jsonify({'message': f'Name or Password Wrong'}), 409



@app.route('/teacher/audio', methods=['POST'])
def create_teacher_audio():
    if 'audio' not in request.files:
        return jsonify({'error': 'Missing audio data'}), 400
    elif 'name' not in request.form:
        return jsonify({'error': 'Missing name data'}), 400

    audio = request.files['audio']

    name = request.form['name']
    teacher_name_sanitized = secure_filename(name)
    filename = f"{teacher_name_sanitized}.wav"
    audio_path = os.path.join(app.config['AUDIO_FOLDER'], filename)

    audio.save(audio_path)

    teacher = Teacher.query.filter_by(name=name).first()
    if teacher is None:
        # Teacher doesn't exist, so create a new one
        teacher = Teacher(name=name, audio_path=audio_path)
        db.session.add(teacher)

    db.session.commit()
    return jsonify({'message': f'Teacher {name} created/updated successfully'}), 201


# Get teacher
@app.route('/teacher/read', methods=['GET', 'POST'])
def read_teacher():
    if request.method == 'POST':
        data = request.json

        # For reading a specific teacher's details by name from the request body
        if data and 'name' in data:
            name = data.get('name')
            teacher = Teacher.query.filter_by(name=name).first()
            if teacher:
                return jsonify({'name': teacher.name, 'audio_path': teacher.audio_path}), 200
            else:
                return jsonify({'error': 'Teacher not found'}), 404
        # Handle missing or malformed data in POST request
        return jsonify({'error': 'Invalid request. Please provide a name.'}), 400

    elif request.method == 'GET':
        teachers = Teacher.query.all()
        teachers_list = [{'name': teacher.name, 'audio_path': teacher.audio_path} for teacher in teachers]
        return jsonify(teachers_list), 200


# Create course
@app.route('/teacher/course', methods=['POST'])
def create_course():
    data = request.json

    if not data or 'name' not in data:
        return jsonify({'error': 'Course name is required'}), 400

    course_name = data['name']
    # Check if the course already exists
    existing_course = Course.query.filter_by(name=course_name).first()

    if existing_course:
        return jsonify({'message': f'Course "{course_name}" already exists.'}), 200

    # Assuming additional data like teacher_name and cover_path are provided in the request
    # and defaulting to placeholders if not provided
    teacher_name = data.get('teacher_name', 'Default Teacher')
    cover_path = data.get('cover_path', 'default_cover.jpg')

    # Create a new course instance and add it to the database
    new_course = Course(name=course_name, teacher_name=teacher_name, cover_path=cover_path)
    db.session.add(new_course)
    db.session.commit()

    return jsonify({'message': f'Course "{course_name}" created successfully.'}), 201


# Create lecture
@app.route('/teacher/course/lecture', methods=['POST'])
def create_lecture():
    data = request.json

    if not data or not all(k in data for k in ('context', 'summary_notes_path')):
        return jsonify({'error': 'Missing data'}), 400

    course_name = data['course_name']
    course = Course.query.filter_by(name=course_name).first()

    if not course:
        # If the course doesn't exist, create it
        course = Course(name=course_name, teacher_name="Default Teacher", cover_path="default_cover.jpg")
        db.session.add(course)
        db.session.flush()  # Flush to assign an ID to the course

    lecture = Lecture(
        course_id=course.id,
        context=data['context'],
        summary_notes_path=data['summary_notes_path']
    )
    db.session.add(lecture)
    db.session.commit()

    return jsonify({'message': f'Lecture "{lecture.id}" created/updated successfully under course "{course_name}".'}), 201


# Get course
@app.route('/course/read', methods=['GET', 'POST'])
def read_course():
    data = request.json
    if request.method == 'POST':
        course_name = data.get('name')
        # Reading a specific course and its lectures
        course = Course.query.filter_by(name=course_name).first()
        if course:
            lectures = Lecture.query.filter_by(course_id=course.id).all()
            lectures_info = [{'lecture_id': lecture.id, 'summary_notes_path': lecture.summary_notes_path, 'context': lecture.context} for lecture in lectures]
            return jsonify({
                'name': course.name,
                'teacher_name': course.teacher_name,
                'cover_path': course.cover_path,
                'lectures': lectures_info
            }), 200
        else:
            return jsonify({'error': 'Course not found'}), 404
    elif request.method == 'GET':
        # Reading all courses
        courses = Course.query.all()
        courses_info = []
        for course in courses:
            lectures = Lecture.query.filter_by(course_id=course.id).all()
            lectures_info = [{'lecture_id': lecture.id, 'summary_notes_path': lecture.summary_notes_path, 'context': lecture.context} for lecture in lectures]
            course_info = {
                'name': course.name,
                'teacher_name': course.teacher_name,
                'cover_path': course.cover_path,
                'lectures': lectures_info
            }
            courses_info.append(course_info)
        return jsonify(courses_info), 200
    return jsonify({'error': 'Invalid request'}), 400


# Student
@app.route('/student/create', methods=['POST'])
def create_student():
    data = request.json

    if not data or not all(k in data for k in ('name',)):
        return jsonify({'error': 'Missing data'}), 400

    name = data['name']
    student = Student.query.filter_by(name=name).first()

    if student:
        return jsonify({'error': 'Student already exists'}), 400
    else:
        student = Student(name=name)
        db.session.add(student)
        db.session.commit()

    return jsonify({'message': f'Student "{name}" created successfully.'}), 201


# Student enroll in course
@app.route('/student/enroll_course', methods=['POST'])
def enroll_course():
    data = request.json

    if not data or not all(k in data for k in ('student_id', 'course_id')):
        return jsonify({'error': 'Missing data'}), 400

    student_id = data['student_id']
    course_id = data['course_id']

    student = Student.query.filter_by(student_id=student_id).first()
    course = Course.query.filter_by(id=course_id).first()

    if not student or not course:
        return jsonify({'error': 'Student or Course not found'}), 404

    enrollment = Enrollment.query.filter_by(student_id=student_id, course_id=course_id).first()

    if enrollment:
        return jsonify({'error': 'Student already enrolled in this course'}), 400
    else:
        enrollment = Enrollment(student_id=student_id, course_id=course_id)
        db.session.add(enrollment)
        db.session.commit()

    return jsonify({'message': f'Student "{student_id}" enrolled in course "{course_id}" successfully.'}), 201


# ChatAgent
# We init for test purpose since we won't call init each time in test
CURR_CHAT_AGENT = None
LECTURE_ID = 0


@app.route('/gemma/init', methods=['POST'])
def chat_init():
    global LECTURE_ID
    LECTURE_ID = request.get_json().get('lecture', '')
    chat_agent = ChatAgent()

    global CURR_CHAT_AGENT
    CURR_CHAT_AGENT = chat_agent

    return jsonify({'lecture': LECTURE_ID}), 200


@app.route('/gemma/extend', methods=['POST'])
def chat_extend():
    query = request.get_json().get('query', '')
    # check first time response
    global CURR_CHAT_AGENT
    chat_agent = CURR_CHAT_AGENT


    if len(chat_agent.get_chat_history()) == 0:
        query = f"Give me a lesson on {query}"

    print(query)
    response = chat_agent.chat('gemma', query, persona='storyteller')
    output = response['answer']
    return jsonify({'response': output}), 200


@app.route('/gemma/talk', methods=['POST'])
def talk_gemma():
    query = request.get_json().get('query', '')
    tone = request.get_json().get('tone', 'nahida')

    global CURR_CHAT_AGENT
    chat_agent = CURR_CHAT_AGENT
    if len(chat_agent.get_chat_history()) == 0:
        query = f"Give me a lesson on {query}"

    print(query)
    response = chat_agent.gemma_chat(query)
    output = response['answer']
    audio_path = tts.generate_audio(output, 'andrew_ng')
    return jsonify({'response': output, 'audioPath': audio_path}), 200


@app.route('/db/reset', methods=['POST'])
def reset_database():
    db.drop_all()
    db.create_all()
    return jsonify({'message': 'Database reset successfully.'}), 200


tts = TTS()


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
    