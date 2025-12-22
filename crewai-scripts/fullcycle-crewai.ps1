# Script de ciclo completo para CrewAI no Kubernetes
# Salve este arquivo como fullcycle-crewai.ps1 na raiz do projeto

Write-Host "🔄 Iniciando ciclo completo do CrewAI..." -ForegroundColor Green

# 1. Deploy
Write-Host "`n🚀 Executando deploy..." -ForegroundColor Cyan
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/

# 2. Monitoramento inicial
Write-Host "`n📡 Monitorando status inicial dos Pods e Serviços..." -ForegroundColor Cyan
kubectl get pods -n crewai
kubectl get svc -n crewai
kubectl get ingress -n crewai
kubectl get pdb -n crewai

# 3. Backup automático dos PVCs
Write-Host "`n💾 Criando snapshots de backup dos PVCs..." -ForegroundColor Cyan

function Backup-PVC {
    param (
        [string]$PVCName,
        [string]$SnapshotName
    )

    $yaml = @"
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: $SnapshotName
  namespace: crewai
spec:
  source:
    persistentVolumeClaimName: $PVCName
"@

    $yaml | kubectl apply -f -
    Write-Host "✅ Snapshot $SnapshotName criado para PVC $PVCName" -ForegroundColor Green
}

# Backup ChromaDB
Backup-PVC -PVCName "chroma-pvc" -SnapshotName "chroma-snapshot-$(Get-Date -Format yyyyMMddHHmm)"

# Backup MLflow
Backup-PVC -PVCName "mlflow-pvc" -SnapshotName "mlflow-snapshot-$(Get-Date -Format yyyyMMddHHmm)"

# Backup Grafana
Backup-PVC -PVCName "grafana-pvc" -SnapshotName "grafana-snapshot-$(Get-Date -Format yyyyMMddHHmm)"

# 4. Monitoramento contínuo
Write-Host "`n📊 Iniciando monitoramento contínuo (CTRL + C para parar)..." -ForegroundColor Yellow
while ($true) {
    Clear-Host
    Write-Host "📦 Pods:" -ForegroundColor Cyan
    kubectl get pods -n crewai

    Write-Host "`n🔌 Serviços:" -ForegroundColor Cyan
    kubectl get svc -n crewai

    Write-Host "`n🌐 Ingress:" -ForegroundColor Cyan
    kubectl get ingress -n crewai

    Write-Host "`n🛡️ PDBs:" -ForegroundColor Cyan
    kubectl get pdb -n crewai

    Write-Host "`n📈 HPA:" -ForegroundColor Cyan
    kubectl get hpa -n crewai

    Write-Host "`n⏳ Atualizando a cada 15 segundos..." -ForegroundColor Magenta
    Start-Sleep -Seconds 15
}
