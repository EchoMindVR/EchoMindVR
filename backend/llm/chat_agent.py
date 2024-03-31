from gemma import gemma_chat
from gemini import gemini_chat
from bakllava import bakllava_chat

class chat_agent:
    def __init__(self):
        pass
    
    def chat(model: str, query: str, persona: str, file_path: str = None, chat_history: list = []):
        if model == "gemma":
            return gemma_chat(query, persona, chat_history)
        if model == "gemini":
            return gemini_chat(query, persona)
        if model == "ballava":
            return bakllava_chat(query, file_path, persona, chat_history)