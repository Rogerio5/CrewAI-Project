Write-Host "=== Gerando relatório em PDF com capa e rodapé ==="

# Caminhos dos arquivos
$csvBasic = ".\results\relatorio-basic.csv"
$csvAdvanced = ".\results\relatorio-advanced.csv"

# Código Python inline
$pythonCode = @"
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
from datetime import datetime

# Carregar dados
df_basic = pd.read_csv(r'$csvBasic')
df_advanced = pd.read_csv(r'$csvAdvanced')

# Data atual
data_atual = datetime.now().strftime('%d/%m/%Y %H:%M')

# Criar PDF
with PdfPages('results/relatorio-final.pdf') as pdf:
    # Página 1 - Capa
    fig, ax = plt.subplots(figsize=(8.5,11))
    ax.axis('off')
    plt.text(0.5, 0.7, 'Relatório de Usuários Weaviate', ha='center', fontsize=20, weight='bold')
    plt.text(0.5, 0.5, f'Gerado em: {data_atual}', ha='center', fontsize=12)
    plt.text(0.5, 0.3, 'Autor: Automação CrewAI', ha='center', fontsize=12)
    pdf.savefig(fig)
    plt.close()

    # Página 2 - Tabela básica
    fig, ax = plt.subplots(figsize=(8,4))
    ax.axis('off')
    table = ax.table(cellText=df_basic.values, colLabels=df_basic.columns, loc='center')
    table.auto_set_font_size(False)
    table.set_fontsize(8)
    table.scale(1, 1.5)
    plt.title('Relatório Básico - Todos os Usuários')
    pdf.savefig(fig)
    plt.close()

    # Página 3 - Tabela avançada
    fig, ax = plt.subplots(figsize=(8,4))
    ax.axis('off')
    table = ax.table(cellText=df_advanced.values, colLabels=df_advanced.columns, loc='center')
    table.auto_set_font_size(False)
    table.set_fontsize(8)
    table.scale(1, 1.5)
    plt.title('Relatório Avançado - Filtro (idade > 30 e email contendo @example.com)')
    pdf.savefig(fig)
    plt.close()

    # Página 4 - Gráfico de barras
    fig, ax = plt.subplots(figsize=(6,4))
    ax.bar(df_basic['Nome'], df_basic['Idade'], color='skyblue')
    ax.set_title('Distribuição de Idades por Usuário')
    ax.set_xlabel('Nome')
    ax.set_ylabel('Idade')
    # Rodapé
    plt.figtext(0.5, 0.01, f'Relatório gerado em {data_atual}', ha='center', fontsize=8)
    pdf.savefig(fig)
    plt.close()

    # Página 5 - Gráfico de pizza
    faixas = {
        'Até 30 anos': (df_basic['Idade'] <= 30).sum(),
        'Acima de 30 anos': (df_basic['Idade'] > 30).sum()
    }
    fig, ax = plt.subplots(figsize=(5,5))
    ax.pie(faixas.values(), labels=faixas.keys(), autopct='%1.1f%%', startangle=90)
    ax.set_title('Proporção de Usuários por Faixa Etária')
    # Rodapé
    plt.figtext(0.5, 0.01, f'Relatório gerado em {data_atual}', ha='center', fontsize=8)
    pdf.savefig(fig)
    plt.close()
"@

# Executar Python
python -c $pythonCode

Write-Host "=== Relatório PDF gerado em results/relatorio-final.pdf ==="
