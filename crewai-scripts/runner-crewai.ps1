# Script runner para CrewAI
# Salve este arquivo como runner-crewai.ps1 na pasta crewai-scripts

Write-Host "🚀 Runner CrewAI - Menu de Automação" -ForegroundColor Green
Write-Host "Selecione o script que deseja executar:" -ForegroundColor Cyan

# Lista de scripts disponíveis
$scripts = @(
    "deploy-crewai.ps1",
    "rollback-crewai.ps1",
    "redeploy-crewai.ps1",
    "monitor-crewai.ps1",
    "logs-crewai.ps1",
    "health-crewai.ps1",
    "stress-crewai.ps1",
    "benchmark-crewai.ps1",
    "metrics-crewai.ps1",
    "diagnostic-crewai.ps1",
    "autoheal-crewai.ps1",
    "backup-crewai.ps1",
    "restore-crewai.ps1",
    "disaster-crewai.ps1",
    "audit-crewai.ps1",
    "security-crewai.ps1",
    "compliance-crewai.ps1",
    "cost-crewai.ps1",
    "scaling-crewai.ps1"
)

# Mostrar menu numerado
for ($i = 0; $i -lt $scripts.Count; $i++) {
    Write-Host "$($i+1). $($scripts[$i])"
}

# Perguntar escolha
$choice = Read-Host "Digite o número do script"

if ($choice -match '^\d+$' -and $choice -ge 1 -and $choice -le $scripts.Count) {
    $scriptToRun = $scripts[$choice-1]
    Write-Host "`n▶️ Executando $scriptToRun..." -ForegroundColor Yellow
    & ".\$scriptToRun"
} else {
    Write-Host "❌ Escolha inválida." -ForegroundColor Red
}
