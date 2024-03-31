from langchain import hub
from langchain.agents import AgentExecutor, create_structured_chat_agent
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_community.chat_models import ChatOllama
from rag import retrieve_docs
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from langchain.callbacks.manager import CallbackManager
from langchain.chains import create_history_aware_retriever
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_core.messages import HumanMessage
from langchain_core.messages import SystemMessage
from langchain_core.prompts import ChatPromptTemplate
from persona import persona_prompt

def gemma_chat(query: str, chat_history: list = [], persona: str = None):
    _qa_system_prompt = persona_prompt(persona) + """\
    Use the following pieces of retrieved context to answer the question.
    {context}"""
    
    _qa_prompt = ChatPromptTemplate.from_messages(
        [
            ("system", _qa_system_prompt),
            MessagesPlaceholder("chat_history"),
            ("human", "{input}"),
        ]
    )

    _contextualize_q_system_prompt = """Given a chat history and the latest user question \
    which might reference context in the chat history, formulate a standalone question \
    which can be understood without the chat history."""

    _contextualize_q_prompt = ChatPromptTemplate.from_messages(
        [
            ("system", _contextualize_q_system_prompt),
            MessagesPlaceholder("chat_history"),
            ("human", "{input}"),
        ]
    )

    callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])

    llm = ChatOllama(model="gemma:7b", temperature=0, callbacks=callback_manager)
    retriever = retrieve_docs(query)
    history_aware_retriever = create_history_aware_retriever(
        llm, retriever.as_retriever(), _contextualize_q_prompt
    )

    question_answer_chain = create_stuff_documents_chain(llm, _qa_prompt)
    rag_chain = create_retrieval_chain(history_aware_retriever, question_answer_chain)
    response = rag_chain.invoke({"input": query, "chat_history": chat_history})
    chat_history.extend([HumanMessage(content=query), response["answer"]])

    return response, chat_history
