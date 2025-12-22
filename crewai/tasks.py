# crewai/tasks.py
from crewai import Task
from crewai.agents import pesquisador, redator, validador

tarefa_pesquisa = Task(
    description=(
        "Pesquisar o tema solicitado, cruzando dados internos (RAG) com fontes externas confiáveis. "
        "Retornar evidências, referências e um sumário dos principais pontos."
    ),
    agent=pesquisador,
    expected_output=(
        "Lista de evidências com trechos relevantes, referências (links/títulos) e um sumário objetivo das descobertas."
    )
)

tarefa_redacao = Task(
    description=(
        "Produzir um relatório estruturado (Introdução, Evidências, Análise, Recomendações), "
        "baseado na saída da pesquisa. Otimizar clareza e objetividade."
    ),
    agent=redator,
    expected_output=(
        "Relatório final com seções claras, bullets quando útil, e recomendações práticas."
    )
)

tarefa_validacao = Task(
    description=(
        "Revisar o relatório quanto a consistência, completude e clareza. "
        "Se houver gaps, listar pontos de melhoria e riscos."
    ),
    agent=validador,
    expected_output=(
        "Checklist de validação com status (OK/ATENÇÃO) e notas específicas; aprovar ou solicitar ajustes."
    )
)

tasks_pipeline = [tarefa_pesquisa, tarefa_redacao, tarefa_validacao]
