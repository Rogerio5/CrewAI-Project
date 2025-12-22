# crewai/tools.py
import os
import json
import requests

def fetch_json(url: str, headers: dict | None = None, timeout: int = 15) -> dict:
    """
    Faz requisição GET e retorna JSON. Lança erro se status != 200.
    """
    resp = requests.get(url, headers=headers or {}, timeout=timeout)
    resp.raise_for_status()
    return resp.json()

def load_local_docs(path: str = "data/docs") -> list[dict]:
    """
    Carrega documentos locais simples (txt/md) para ingestão no RAG.
    Retorna lista de dicts {id, text, metadata}.
    """
    docs = []
    if not os.path.isdir(path):
        return docs
    for fname in os.listdir(path):
        fpath = os.path.join(path, fname)
        if os.path.isfile(fpath) and any(fname.endswith(ext) for ext in (".txt", ".md")):
            with open(fpath, "r", encoding="utf-8") as f:
                text = f.read()
            docs.append({
                "id": fname,
                "text": text,
                "metadata": {"source": f"local:{fname}"}
            })
    return docs

def bootstrap_rag():
    """
    Ingestão inicial dos documentos locais no índice Chroma.
    """
    from crewai.rag_store import rag_ingest
    docs = load_local_docs()
    if docs:
        rag_ingest(docs)
