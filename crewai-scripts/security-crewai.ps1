# Script de security scan para CrewAI no Kubernetes
# Salve este arquivo como security-crewai.ps1 na raiz do projeto

Write-Host "🔒 Iniciando security scan do cluster CrewAI..." -ForegroundColor Green

# Criar pasta de relatórios
$timestamp = Get-Date -Format "yyyyMMddHHmm"
$reportDir = "security-report-$timestamp"
New-Item -ItemType Directory -Path $reportDir | Out-Null

# Função para salvar saída de comandos em arquivos
function Save-Report {
    param (
        [string]$Command,
        [string]$FileName
    )

    Write-Host "📝 Coletando: $FileName" -ForegroundColor Cyan
    Invoke-Expression $Command | Out-File "$reportDir\$FileName.txt"
}

# 1. Pods rodando como root
Write-Host "`n👀 Verificando pods rodando como root..." -ForegroundColor Yellow
kubectl get pods -n crewai -o json | ConvertFrom-Json | 
    Select-Object -ExpandProperty items | 
    ForEach-Object {
        $podName = $_.metadata.name
        foreach ($container in $_.spec.containers) {
            if ($container.securityContext.runAsUser -eq 0) {
                Write-Host "⚠️ Pod $podName está rodando como root!" -ForegroundColor Red
                Add-Content "$reportDir\pods-root.txt" "Pod $podName roda como root"
            }
        }
    }

# 2. Secrets expostos
Write-Host "`n🔑 Listando secrets..." -ForegroundColor Yellow
Save-Report -Command "kubectl get secret -n crewai -o yaml" -FileName "secrets"

# 3. Roles e permissões
Write-Host "`n🛡️ Verificando permissões (Roles e RoleBindings)..." -ForegroundColor Yellow
Save-Report -Command "kubectl get roles -n crewai -o yaml" -FileName "roles"
Save-Report -Command "kubectl get rolebindings -n crewai -o yaml" -FileName "rolebindings"
Save-Report -Command "kubectl get clusterroles -o yaml" -FileName "clusterroles"
Save-Report -Command "kubectl get clusterrolebindings -o yaml" -FileName "clusterrolebindings"

Write-Host "`n✅ Security scan concluído! Relatórios salvos em: $reportDir" -ForegroundColor Green
