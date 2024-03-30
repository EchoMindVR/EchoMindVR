from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import Chroma
from langchain_community.document_loaders.merge import MergedDataLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.embeddings.sentence_transformer import (
    SentenceTransformerEmbeddings,
)
import pickle
import os

def load_pdfs_into_chroma_db():
    first_flag = True
    # Load and split the pages of all PDF documents in documents directory
    base_dir = os.path.dirname(__file__)
    documents_folder = os.path.join(base_dir, 'documents')
    for file in os.listdir(documents_folder):
        if first_flag:
            merge_loader = PyPDFLoader(os.path.join(documents_folder, file))
            first_flag = False
        if file.endswith(".pdf"):
            loader = PyPDFLoader(os.path.join(documents_folder, file))
            merge_loader = MergedDataLoader(loaders=[merge_loader, loader])

    pages = merge_loader.load()

    text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
    pages = text_splitter.split_documents(pages)

    embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    chroma_dir = os.path.join(base_dir, 'chroma_db')
    vectorstore = Chroma.from_documents(pages, embedding_function, persist_directory=chroma_dir)