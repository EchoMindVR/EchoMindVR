from langchain import hub
from langchain.agents import AgentExecutor, create_structured_chat_agent
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_community.chat_models import ChatOllama
from llm.rag import retrieve_docs
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from langchain.callbacks.manager import CallbackManager
from langchain.chains import create_history_aware_retriever
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_core.messages import HumanMessage


class ChatAgent():
    def __init__(self, lecture:str|None=None) -> None:
        _qa_system_prompt = """You are an assistant for question-answering tasks. \
        Use the following pieces of retrieved context to answer the question. \
        If you don't know the answer, just say that you don't know. \
        Use three sentences maximum and keep the answer concise.\

        {context}"""
        self._qa_prompt = ChatPromptTemplate.from_messages(
            [
                ("system", _qa_system_prompt),
                MessagesPlaceholder("chat_history"),
                ("human", "{input}"),
            ]
        )
        self.lecture = lecture
        _contextualize_q_system_prompt = """Given a chat history and the latest user question \
        which might reference context in the chat history, formulate a standalone question \
        which can be understood without the chat history. Do NOT answer the question, \
        just reformulate it if needed and otherwise return it as is."""

        self._contextualize_q_prompt = ChatPromptTemplate.from_messages(
            [
                ("system", _contextualize_q_system_prompt),
                MessagesPlaceholder("chat_history"),
                ("human", "{input}"),
            ]
        )

        self.callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])
        self.chat_history = []

    def gemma_chat(self, query: str):
        llm = ChatOllama(model="gemma:7b", temperature=0, callbacks=self.callback_manager)
        retriever = retrieve_docs(query)
        history_aware_retriever = create_history_aware_retriever(
            llm, retriever.as_retriever(), self._contextualize_q_prompt
        )

        question_answer_chain = create_stuff_documents_chain(llm, self._qa_prompt)
        rag_chain = create_retrieval_chain(history_aware_retriever, question_answer_chain)
        response = rag_chain.invoke({"input": query, "chat_history": self.chat_history})
        self.chat_history.extend([HumanMessage(content=query), response["answer"]])

        return response
    
    def get_chat_history(self):
        return self.chat_history