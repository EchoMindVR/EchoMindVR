from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import Chroma
from langchain_community.document_loaders.merge import MergedDataLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.embeddings.sentence_transformer import (
    SentenceTransformerEmbeddings,
)
import pickle
import os

first_flag = True
# Load and split the pages of all PDF documents in documents directory
for file in os.listdir("documents"):
    if first_flag:
        merge_loader = PyPDFLoader(f"documents/{file}")
        first_flag = False
    if file.endswith(".pdf"):
        loader = PyPDFLoader(f"documents/{file}")
        merge_loader = MergedDataLoader(loaders=[merge_loader, loader])

pages = merge_loader.load()

text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
pages = text_splitter.split_documents(pages)

embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
vectorstore = Chroma.from_documents(pages, embedding_function, persist_directory='./chroma_db')