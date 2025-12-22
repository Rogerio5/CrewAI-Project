Write-Host "=== Fluxo completo iniciado ==="

# Caminho do log
$logPath = ".\results\log.txt"

# Função auxiliar para logar
function Log($mensagem, $status="INFO") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [$status] - $mensagem" | Out-File -FilePath $logPath -Append -Encoding utf8
    Write-Host "$status - $mensagem"
}

# Início do log
"=== Início do fluxo em $(Get-Date) ===" | Out-File -FilePath $logPath -Encoding utf8

try {
    Log "Aplicando schema..." "INFO"
    curl.exe -X POST http://localhost:8080/v1/schema `
      -H "Content-Type: application/json" `
      -d "@schema.json" | Out-File -Append $logPath
    Log "Schema aplicado com sucesso." "SUCCESS"
} catch {
    Log "Erro ao aplicar schema: $_" "ERROR"
}

try {
    Log "Inserindo documentos..." "INFO"
    .\insert-documents.ps1 | Out-File -Append $logPath
    Log "Documentos inseridos com sucesso." "SUCCESS"
} catch {
    Log "Erro ao inserir documentos: $_" "ERROR"
}

try {
    Log "Inserindo usuários..." "INFO"
    .\insert-users.ps1 | Out-File -Append $logPath
    Log "Usuários inseridos com sucesso." "SUCCESS"
} catch {
    Log "Erro ao inserir usuários: $_" "ERROR"
}

try {
    Log "Rodando query básica..." "INFO"
    .\query-basic.ps1 | Out-File -Append $logPath
    Log "Query básica executada com sucesso." "SUCCESS"
} catch {
    Log "Erro na query básica: $_" "ERROR"
}

try {
    Log "Rodando query avançada..." "INFO"
    .\query-advanced.ps1 | Out-File -Append $logPath
    Log "Query avançada executada com sucesso." "SUCCESS"
} catch {
    Log "Erro na query avançada: $_" "ERROR"
}

try {
    Log "Analisando resultados..." "INFO"
    .\analyze-results.ps1 | Out-File -Append $logPath
    Log "Resultados analisados com sucesso." "SUCCESS"
} catch {
    Log "Erro na análise de resultados: $_" "ERROR"
}

try {
    Log "Gerando gráficos..." "INFO"
    .\dashboard.ps1 | Out-File -Append $logPath
    Log "Gráficos gerados com sucesso." "SUCCESS"
} catch {
    Log "Erro ao gerar gráficos: $_" "ERROR"
}

try {
    Log "Gerando relatório PDF..." "INFO"
    .\report.ps1 | Out-File -Append $logPath
    Log "Relatório PDF gerado com sucesso." "SUCCESS"
} catch {
    Log "Erro ao gerar relatório PDF: $_" "ERROR"
}

try {
    Log "Enviando relatório por e-mail..." "INFO"
    .\send-report-gmail-multi.ps1 | Out-File -Append $logPath
    Log "Relatório enviado com sucesso." "SUCCESS"
} catch {
    Log "Erro ao enviar relatório: $_" "ERROR"
}

Log "Fluxo completo finalizado." "INFO"
