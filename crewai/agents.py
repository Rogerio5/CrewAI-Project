# crewai/agents.py
import os
from crewai import Agent
from crewai_tools import tool

# Ferramenta: busca contextual no RAG
@tool("Buscar no repositório interno (RAG)")
def rag_query_tool(query: str) -> str:
    """
    Consulta ao índice vetorial interno para recuperar contexto relevante.
    """
    from crewai.rag_store import rag_search  # import local para evitar ciclos
    return rag_search(query)

# Ferramenta: chamada HTTP externa (ex.: APIs públicas)
@tool("Chamada HTTP externa")
def http_get_tool(url: str) -> str:
    import requests
    resp = requests.get(url, timeout=15)
    resp.raise_for_status()
    return resp.text

# Ferramenta: sumarização
@tool("Sumarizar texto longo")
def summarize_tool(text: str) -> str:
    # Aqui você pode chamar um LLM local/hosted para sumarização.
    # Placeholder simples:
    return text[:1800] + ("..." if len(text) > 1800 else "")

# Agente Pesquisador
pesquisador = Agent(
    role="Pesquisador",
    goal="Levantar informações atualizadas e confiáveis sobre o tema solicitado, usando RAG e fontes externas.",
    backstory="Analista sênior com experiência em curadoria de conteúdo técnico e verificação de fontes.",
    tools=[rag_query_tool, http_get_tool],
    verbose=True,
    allow_delegation=False
)

# Agente Redator
redator = Agent(
    role="Redator técnico",
    goal="Transformar achados em um relatório claro, estruturado e acionável.",
    backstory="Especialista em comunicação técnica e síntese executiva.",
    tools=[summarize_tool],
    verbose=True,
    allow_delegation=False
)

# Agente Validador
validador = Agent(
    role="Validador",
    goal="Revisar consistência, completude e clareza; apontar gaps e riscos.",
    backstory="Auditor de qualidade de documentação com foco em precisão e evidências.",
    tools=[],
    verbose=True,
    allow_delegation=False
)
