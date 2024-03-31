# EchoMindVR
<img width="713" alt="main" src="https://github.com/EchoMindVR/EchoMindVR/assets/86748529/b36cd3df-c9c6-4bed-a9e9-d00ca4d6e4ec" style="display: block; margin: 0 auto;">

## Inspiration
With the current methods of in person learning, there is not sufficient educational resources for every student. However, majority of online courses do not effectively simulate a classroom environment, where there is a lack of interaction between a student and instructor. EchoMindVR aims to bridge this gap, increasing the quality of education and creating a personalizable online learning environment for everyone. 

## What it does
Designed to engage students in interactive lessons through a wide range of courses created by the teachers, EchoMindVR is an innovative educational platform that leverages AI to simulate real-time conversations for students in various voices and styles. The immersive VR environment simulates a classroom, providing the best of both worlds. Teachers are able to upload course content along with an audio recording of their own voice which is used to generate an interactive lecture. By engaging with the LLM assisted instructor, the student is able to ask questions and receive answers in real-time. This way, students are encouraged to explore topics more deeply, fostering a deeper understanding with the material

<img width="713" alt="course_lectures" src="https://github.com/EchoMindVR/EchoMindVR/assets/86748529/caec03d3-65d0-43ba-b1f5-28fe45d10c12" style="display: block; margin: 0 auto;">

## How we built it
Building EchoMindVR involved an interdisciplinary approach, combining expertise in web and app design, AI/ML, voice synthesis, and educational content creation. We utilized Python, Flask, SQL Alchemy for backend and database development, Werkzeug for file security, incorporating various models for audio generation and LLMs for lecture content generation. The immersive VR environment was developed using Swift for an Apple Vision Pro simulator, creating an user-friendly interface to immerse the student in the classroom. Lecture content development focuses on retrieval augmented generation (RAG) to fetch relevant information, feeding to fine-tune LLMs to create analysis and explanation for the student. The team also cared about security in AI when developing the project. We employed Werkzeug, which significantly helped secure filename for file uploads. The LLMs were fine-tuned with RAG and LangChain to provide content and data safety.

<img width="713" alt="course_lectures" src="https://github.com/EchoMindVR/EchoMindVR/assets/86748529/e418f2fd-24ae-4a87-bf5f-54124430d63d" style="display: block; margin: 0 auto;">

## Challenges we ran into
The team ran into various challenges throughout the development cycle as we were first time users for majority of the applications for this project. Database querying provided a great deal of difficulty, along with ensuring real-time responsiveness when connecting the backend to frontend. Additionally, designing the appearance of the app was a steep learning curve as it was our first time using Swift and the recently released Apple Vision Pro simulator. Connecting all the parts to ensure a coherence content output posed a challenge because we had to learn the ins and outs of each ML model. 

## Accomplishments that we're proud of
We are extremely proud of our ability to connect all the pieces of our project together to produce a usable platform that genuinely excites students about learning. Many fields of software development were used, including full stack development, machine learning, as well as UI development. We used many LLMs in the project, including the best open-sourced language model, Gemma, open-sourced multimodal, BakLLaVA, and the state of the art model, Gemini. 

<img width="713" alt="teacher_preparing" src="https://github.com/EchoMindVR/EchoMindVR/assets/86748529/e1936ef5-c30e-44cb-bea0-b069cbd9c147" style="display: block; margin: 0 auto;">

## What we learned
As mentioned earlier, every step of creating this project was a learning journey. We became more familiar with recently released state of the art models, learned many aspects of full-stack development, and enjoyed experimentation of a new VR environment. It was a big step for us in educational software development. 

## What's next for EchoMindVR
There are many brainstormed ideas that we were not able to implement but would like to explore further for EchoMindVR. One of the main directions is to implement multiple agents that are specialized for various tasks. This would allow us to generate a greater variety of tools to aid the student, such as graphs (Desmos), images and diagrams, and videos (Sora). It would also be nice to experiment with the real Apple Vision Pro headset which we were unfortunately not able to afford for this hackathon :(
But hopefully in the future!
