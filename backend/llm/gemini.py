import os
from langchain_core.messages import HumanMessage
from langchain import hub
from langchain.agents import AgentExecutor, create_json_chat_agent, load_tools
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain_core.prompts import ChatPromptTemplate
from langchain.pydantic_v1 import BaseModel, Field
from langchain_google_vertexai import ChatVertexAI
from langchain.tools import BaseTool, StructuredTool, tool
from langchain.docstore.document import Document
from llm.persona import persona_prompt
from llm.rag import retrieve_docs
from dotenv import load_dotenv
load_dotenv()
os.environ["WOLFRAM_ALPHA_APPID"] = os.getenv("WOLFRAM_ALPHA_APPID")

llm = ChatVertexAI(model_name="gemini-pro-vision", temperature=0, stop=['Observation:'], convert_system_message_to_human=True)

def create_image_message(query, image_url):
    return [HumanMessage(
        content=[
            {
                "type": "text",
                "text": query
            },  # You can optionally provide text parts
            {"type": "image_url", "image_url": {"url": image_url}},
        ]
    )]

@tool
def vision_generate(query: str, file_path: str):
    """Use the vision model to generate text from an image.
    query: str: The image to generate text from.
    file_path: str: The path to the image file.
    THERE ARE TWO PARAMETERS
    """
    query = create_image_message(query, file_path)
    return llm.invoke(query)

@tool
def retrieval_augmented_generation(query: str):
    """Use the retrieval augmented generation to retrieve relevant documents from tavily search, arxiv.org and lecture pdfs.
    query: str: The query to search for.
    THERE IS ONLY ONE QUERY PARAMETER
    """
    retriever = retrieve_docs(query).as_retriever(search_type="mmr", search_kwargs={'k': 4})
    docs = retriever.get_relevant_documents(query)
    return "\n\n".join(doc.page_content for doc in docs)

@tool
def wolfram_alpha_query(query: str):
    """Use the Wolfram Alpha API to get the result of a math query.
    query: str: The query to search for.
    THERE IS ONLY ONE QUERY PARAMETER
    """
    return WolframAlphaAPIWrapper().run(query) + "\n"

def gemini_chat(query: str, persona: str = None, file_path: str = None):
    tools = [wolfram_alpha_query, retrieval_augmented_generation, vision_generate]

    prompt = hub.pull("kenwu/react-json")


    if file_path is not None:
        query = "I have an image to share with you at the following path: " + file_path + "\n" + query

    if persona is not None:
        query = persona_prompt(persona) + "\n" + query

    # Create the agent
    agent = create_json_chat_agent(llm, tools, prompt)

    # Create an agent executor by passing in the agent and tools
    agent_executor = AgentExecutor(
        agent=agent,
        tools=tools,
        verbose=True,
        handle_parsing_errors=True,
        max_iterations=5,
        return_intermediate_steps=True
    )

    query = {
        'input': {query},
    }

    response = agent_executor.invoke(query)
    return response