# Script de backup para CrewAI no Kubernetes
# Salve este arquivo como backup-crewai.ps1 na raiz do projeto

Write-Host "💾 Iniciando backup dos PVCs (ChromaDB, MLflow, Grafana)..." -ForegroundColor Green

# Função para criar snapshot de PVC
function Backup-PVC {
    param (
        [string]$PVCName,
        [string]$SnapshotName
    )

    Write-Host "`n📦 Criando snapshot para PVC: $PVCName" -ForegroundColor Cyan

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

Write-Host "`n💾 Backup concluído com sucesso!" -ForegroundColor Green
