param(
    [string]$queryFile = "query-combinada-todas.json"
)

# Carregar o arquivo JSON
$queriesJson = Get-Content $queryFile -Raw | ConvertFrom-Json

Write-Host "=== Queries disponíveis ==="
for ($i = 0; $i -lt $queriesJson.queries.Count; $i++) {
    Write-Host "$i - $($queriesJson.queries[$i].name)"
}

# Perguntar qual query rodar
$choice = Read-Host "Digite o número da query que deseja executar"
if ($choice -match '^\d+$' -and $choice -lt $queriesJson.queries.Count) {
    $selectedQuery = $queriesJson.queries[$choice].query
    Write-Host "Executando query: $($queriesJson.queries[$choice].name)"
    
    # Montar payload JSON
    $payload = @{ query = $selectedQuery } | ConvertTo-Json -Compress
    
    # Rodar no Weaviate
    curl.exe -X POST http://localhost:8080/v1/graphql `
      -H "Content-Type: application/json" `
      -d $payload
} else {
    Write-Host "Escolha inválida."
}
