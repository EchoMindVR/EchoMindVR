from langchain_community.retrievers import TavilySearchAPIRetriever
from langchain_community.retrievers import ArxivRetriever
from langchain.vectorstores import Chroma
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores.utils import filter_complex_metadata
from langchain_community.embeddings.sentence_transformer import (
    SentenceTransformerEmbeddings,
)
from langchain.text_splitter import RecursiveCharacterTextSplitter

text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
tavily_retriever = TavilySearchAPIRetriever(k=3)
arxiv_retriever = ArxivRetriever(load_max_docs=2)

def retrieve_docs(query: str):
    tavily_results = tavily_retriever.invoke(query)
    tavily_results = text_splitter.split_documents(tavily_results)
    tavily_results = filter_complex_metadata(tavily_results)
    
    arxiv_results = arxiv_retriever.get_relevant_documents(query)
    arxiv_results = text_splitter.split_documents(arxiv_results)
    arxiv_results = filter_complex_metadata(arxiv_results)
   
    chromadb = Chroma(persist_directory='./chroma_db', embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2"))
    
    try:
        chromadb.add_documents(tavily_results)
    except:
        pass
    try:
        chromadb.add_documents(arxiv_results)
    except:
        pass
    return chromadb