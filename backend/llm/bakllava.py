from langchain import hub
from langchain.agents import AgentExecutor, create_structured_chat_agent
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_community.llms import Ollama
from rag import retrieve_docs
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from langchain.callbacks.manager import CallbackManager
from langchain.chains import create_history_aware_retriever
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_core.messages import HumanMessage
from persona import persona_prompt
import base64
from PIL import Image
from io import BytesIO

def convert_to_base64(pil_image):
    """
    Convert PIL images to Base64 encoded strings

    :param pil_image: PIL image
    :return: Re-sized Base64 string
    """

    buffered = BytesIO()
    pil_image.save(buffered, format="JPEG")  # You can change the format if needed
    img_str = base64.b64encode(buffered.getvalue()).decode("utf-8")
    return img_str

def bakllava_chat(query: str, file_path: str, chat_history: list = [], persona: str = None):
    pil_image = Image.open(file_path)
    image_b64 = convert_to_base64(pil_image)
    
    _qa_system_prompt = persona_prompt(persona) + """\
    Use the following pieces of retrieved context to answer the question. \
    If you don't know the answer, just say that you don't know. \
    Use three sentences maximum and keep the answer concise.\

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
    which can be understood without the chat history. Do NOT answer the question, \
    just reformulate it if needed and otherwise return it as is."""

    _contextualize_q_prompt = ChatPromptTemplate.from_messages(
        [
            ("system", _contextualize_q_system_prompt),
            MessagesPlaceholder("chat_history"),
            ("human", "{input}"),
        ]
    )

    llm = Ollama(model="bakllava", temperature=0)
    llm_with_image_context = llm.bind(images=[image_b64])

    retriever = retrieve_docs(query)
    history_aware_retriever = create_history_aware_retriever(
        llm, retriever.as_retriever(), _contextualize_q_prompt
    )

    question_answer_chain = create_stuff_documents_chain(llm, _qa_prompt)

    rag_chain = create_retrieval_chain(history_aware_retriever, question_answer_chain)

    response = rag_chain.invoke({"input": query, "chat_history": chat_history})

    chat_history.extend([HumanMessage(content=query), response["answer"]])

    return response, chat_history