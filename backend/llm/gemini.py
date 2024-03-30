from langchain import hub
from langchain.agents import AgentExecutor, create_structured_agent
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.pydantic_v1 import BaseModel, Field
from langchain.tools import BaseTool, StructuredTool, tool
from rag import retrieve_docs

import os
from dotenv import load_dotenv
load_dotenv()

os.environ["WOLFRAM_ALPHA_APPID"] = os.getenv("WOLFRAM_ALPHA_APPID")
os.environ["GOOGLE_API_KEY"] = os.getenv("GOOGLE_API_KEY")

@tool
def rag(query: str) -> str:
    """Use the retrieval augmented generation to retrieve relevant documents from tavily search, arxiv.org and lecture pdfs."""
    retriever = retrieve_docs(query)
    docs = retriever.invoke(query)
    return "\n\n".join(doc.page_content for doc in docs)

def gemini_chat(query: str, chat_history: list = [], image_url: str = None):
    if image:
        llm = ChatGoogleGenerativeAI(model="gemini-pro-vision", temperature=0)
        query = HumanMessage(
            content=[
                {
                    "type": "text",
                    "text": query,
                },  # You can optionally provide text parts
                {"type": "image_url", "image_url": image_url},
            ]
        )
    else:
        llm = ChatGoogleGenerativeAI(model="gemini-pro", temperature=0)

    prompt = hub.pull("kenwu/react-json")
    tools = [WolframAlphaAPIWrapper(), rag]

    # Create the agent
    agent = create_structured_chat_agent(llm, tools, prompt)

    # Create an agent executor by passing in the agent and tools
    agent_executor = AgentExecutor(
        agent=agent, tools=tools, verbose=True, handle_parsing_errors=True
    )

    response = agent_executor.invoke(
        {
            "input": query,
            "chat_history": chat_history,
        }
    )
    if image:
        chat_history.extend([HumanMessage(content=query.content[0]['text'])], response["output"])
    else:
        chat_history.extend([HumanMessage(content=query), response["output"]])

    return response, chat_history