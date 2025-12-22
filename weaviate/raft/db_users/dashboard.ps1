Write-Host "=== Gerando dashboard com gráficos ==="

# Caminhos dos arquivos
$csvBasic = ".\results\relatorio-basic.csv"

# Código Python inline
$pythonCode = @"
import pandas as pd
import matplotlib.pyplot as plt

# Carregar dados
df_basic = pd.read_csv(r'$csvBasic')

# Gráfico 1: Barras - Nome x Idade
plt.figure(figsize=(6,4))
plt.bar(df_basic['Nome'], df_basic['Idade'], color='skyblue')
plt.title('Distribuição de Idades por Usuário')
plt.xlabel('Nome')
plt.ylabel('Idade')
plt.tight_layout()
plt.savefig('results/grafico-barras.png')  # salvar como PNG
plt.show()

# Gráfico 2: Pizza - Faixas Etárias
faixas = {
    'Até 30 anos': (df_basic['Idade'] <= 30).sum(),
    'Acima de 30 anos': (df_basic['Idade'] > 30).sum()
}
plt.figure(figsize=(5,5))
plt.pie(faixas.values(), labels=faixas.keys(), autopct='%1.1f%%', startangle=90)
plt.title('Proporção de Usuários por Faixa Etária')
plt.savefig('results/grafico-pizza.png')  # salvar como PNG
plt.show()
"@

# Executar Python
python -c $pythonCode

Write-Host "=== Dashboard concluído. Gráficos salvos em results/ ==="
