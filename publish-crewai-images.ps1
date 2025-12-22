# ================================
# Script: publish-crewai-images.ps1
# ================================

$images = @(
    @{ local="rogerio/crewai-api:latest"; remote="rogerio1994/crewaiapi:latest"; app="crewai-api" },
    @{ local="rogerio/crewai-agents:latest"; remote="rogerio1994/crewaiagents:latest"; app="crewai-agents" },
    @{ local="rogerio/mlflow:latest"; remote="rogerio1994/mlflow:latest"; app="mlflow" },
    @{ local="rogerio/chromadb:latest"; remote="rogerio1994/chromadb:latest"; app="chromadb" }
)

Write-Host "Iniciando publicação das imagens do CrewAI..."

# 1. Taguear e enviar imagens
foreach ($img in $images) {
    Write-Host "Tagueando imagem: $($img.local) → $($img.remote)"
    docker tag $img.local $img.remote

    Write-Host "Enviando para Docker Hub: $($img.remote)"
    docker push $img.remote
}

# 2. Atualizar os manifests
$manifestPath = "k8s/deployment.yaml"
Write-Host "Atualizando manifest: $manifestPath"
(Get-Content $manifestPath) -replace "rogerio/", "rogerio1994/" | Set-Content $manifestPath

# 3. Aplicar os manifests
Write-Host "Aplicando os manifests atualizados no Kubernetes..."
kubectl apply -f k8s/

# 4. Reiniciar os pods
foreach ($img in $images) {
    Write-Host "Reiniciando pods do app: $($img.app)"
    kubectl delete pod -n crewai -l app=$($img.app)
}

Write-Host "`nProcesso concluído com sucesso: imagens publicadas, manifests atualizados e pods reiniciados!"
