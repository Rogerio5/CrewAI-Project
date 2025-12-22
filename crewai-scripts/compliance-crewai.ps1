# Script de compliance-check para CrewAI no Kubernetes
# Salve este arquivo como compliance-crewai.ps1 na raiz do projeto

Write-Host "📑 Iniciando compliance-check do cluster CrewAI..." -ForegroundColor Green

# Criar pasta de relatórios
$timestamp = Get-Date -Format "yyyyMMddHHmm"
$reportDir = "compliance-report-$timestamp"
New-Item -ItemType Directory -Path $reportDir | Out-Null

# Função para salvar saída de comandos em arquivos
function Save-Report {
    param (
        [string]$Command,
        [string]$FileName
    )

    Write-Host "📝 Validando: $FileName" -ForegroundColor Cyan
    Invoke-Expression $Command | Out-File "$reportDir\$FileName.txt"
}

# 1. Namespaces
Write-Host "`n📂 Verificando namespaces..." -ForegroundColor Yellow
Save-Report -Command "kubectl get ns" -FileName "namespaces"

# 2. Labels nos pods
Write-Host "`n🏷️ Verificando labels nos pods..." -ForegroundColor Yellow
kubectl get pods -n crewai --show-labels | Out-File "$reportDir\pods-labels.txt"

# 3. Resource Limits
Write-Host "`n⚖️ Verificando resource limits..." -ForegroundColor Yellow
kubectl get pods -n crewai -o json | ConvertFrom-Json | 
    Select-Object -ExpandProperty items | 
    ForEach-Object {
        $podName = $_.metadata.name
        foreach ($container in $_.spec.containers) {
            if (-not $container.resources.limits) {
                Write-Host "⚠️ Pod $podName não possui resource limits definidos!" -ForegroundColor Red
                Add-Content "$reportDir\resource-limits.txt" "Pod $podName sem resource limits"
            }
        }
    }

# 4. Network Policies
Write-Host "`n🌐 Verificando network policies..." -ForegroundColor Yellow
Save-Report -Command "kubectl get networkpolicy -n crewai" -FileName "network-policies"

# 5. Pod Security Standards
Write-Host "`n🔒 Verificando PodSecurityStandards..." -ForegroundColor Yellow
Save-Report -Command "kubectl get psp" -FileName "pod-security-policies"

Write-Host "`n✅ Compliance-check concluído! Relatórios salvos em: $reportDir" -ForegroundColor Green
