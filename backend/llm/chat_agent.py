from llm.gemma import gemma_chat
from llm.gemini import gemini_chat
from llm.bakllava import bakllava_chat

class ChatAgent:
    def __init__(self):
        self.chat_history = []

    def chat(self, model: str, query: str, persona: str = None, file_path: str = None):
        if model == "gemma":
            response, chat_history = gemma_chat(query, persona, self.chat_history)
            self.chat_history.extend(chat_history)
            return response
        if model == "gemini":
            return gemini_chat(query, persona)
        if model == "bakllava":
            response, chat_history = bakllava_chat(
                query, file_path, self.chat_history, persona)
            self.chat_history.extend(chat_history)
            return response

    def get_chat_history(self):
        return self.chat_history