# Script de teste para API CrewAI
# Gera token JWT e dispara requisições para /crew

Write-Host "Gerando token JWT..."
$response = Invoke-RestMethod -Uri "http://localhost:8000/token" `
  -Method Post `
  -ContentType "application/x-www-form-urlencoded" `
  -Body "username=admin&password=admin123"

$token = $response.access_token
Write-Host "Token obtido: $token"
Write-Host ""

# Disparar múltiplas requisições para /crew
for ($i = 1; $i -le 5; $i++) {
    Write-Host ("Enviando requisição {0}..." -f $i)
    $body = @{ topic = "teste-observabilidade-$i" } | ConvertTo-Json
    try {
        $resp = Invoke-RestMethod -Uri "http://localhost:8000/crew" `
          -Method Post `
          -Headers @{Authorization = "Bearer $token"} `
          -ContentType "application/json" `
          -Body $body

        Write-Host "Resposta recebida:"
        $resp | ConvertTo-Json -Depth 5 | Write-Output
    }
    catch {
        Write-Host ("Erro na requisição {0}:" -f $i)
        Write-Host $_.Exception.Message
    }

    # Pequena pausa entre requisições (simula uso real)
    Start-Sleep -Seconds 1
    Write-Host ""
}
