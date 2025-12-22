import os
from typing import List
import chromadb
from chromadb.utils import embedding_functions

# Configuração do Chroma (persistência em ./data/chroma)
_chroma_client = chromadb.PersistentClient(path=os.path.join("data", "chroma"))

_collection_name = "docs"
_collection = _chroma_client.get_or_create_collection(
    name=_collection_name,
    embedding_function=embedding_functions.DefaultEmbeddingFunction()
)

def rag_ingest(docs: List[dict]) -> None:
    """
    Ingestão de documentos no índice RAG.
    docs: lista de dicts com {id, text, metadata}
    """
    ids = [d["id"] for d in docs]
    texts = [d["text"] for d in docs]
    metadatas = [d.get("metadata", {}) for d in docs]

    _collection.upsert(documents=texts, ids=ids, metadatas=metadatas)

def rag_search(query: str, n_results: int = 5) -> str:
    """
    Busca contextual no índice RAG.
    Retorna um bloco de contexto consolidado.
    """
    res = _collection.query(query_texts=[query], n_results=n_results)
    docs = res.get("documents", [[]])[0]
    metas = res.get("metadatas", [[]])[0]

    context_blocks = []
    for i, doc in enumerate(docs):
        meta = metas[i] if i < len(metas) else {}
        src = meta.get("source", meta.get("title", "desconhecido"))
        context_blocks.append(f"- Fonte: {src}\n{doc}\n")

    return "\n".join(context_blocks) if context_blocks else "Nenhum contexto encontrado."
