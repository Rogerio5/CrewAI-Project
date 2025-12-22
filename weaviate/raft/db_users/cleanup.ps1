param(
    [string]$className = "User",       # Classe padrão
    [string]$keyProperty = "email"     # Propriedade usada como chave
)

$logFile = "duplicatas.txt"
$exportFile = "backup_$className.json"

Add-Content $logFile "`n=== Limpeza da classe $className - $(Get-Date) ==="

Write-Host "Buscando todos os objetos da classe $className..."
$response = curl.exe http://localhost:8080/v1/objects
$json = $response | ConvertFrom-Json

# Filtrar apenas objetos da classe escolhida
$objects = $json.objects | Where-Object { $_.class -eq $className }

Write-Host "Encontrados $($objects.Count) objetos da classe $className."
Add-Content $logFile "Total encontrados: $($objects.Count)"

# Agrupar por chave escolhida
$grouped = $objects | Group-Object { $_.properties.$keyProperty }

foreach ($group in $grouped) {
    $key = $group.Name
    $objs = $group.Group

    if ($objs.Count -gt 1) {
        Write-Host "Duplicata encontrada: $key ($($objs.Count) registros)"
        Add-Content $logFile "Duplicata: $key ($($objs.Count) registros)"

        # Mantém o primeiro e mostra os demais
        $toDelete = $objs | Select-Object -Skip 1

        foreach ($obj in $toDelete) {
            $id = $obj.id
            Write-Host "ID duplicado: $id"
            Add-Content $logFile "ID duplicado: $id"
        }

        # Pergunta se deve deletar
        $confirm = Read-Host "Deseja deletar os duplicados de $key? (S/N)"
        if ($confirm -eq "S") {
            foreach ($obj in $toDelete) {
                $id = $obj.id
                Write-Host "Deletando duplicata com ID: $id"
                Add-Content $logFile "Deletado ID: $id"
                curl.exe -X DELETE "http://localhost:8080/v1/objects/$id"
            }
        } else {
            Write-Host "Nenhum registro deletado para $key."
            Add-Content $logFile "Nenhum registro deletado para $key."
        }
    }
}

# Exportar objetos únicos restantes
Write-Host "Exportando objetos únicos para $exportFile..."
$uniqueObjects = $json.objects | Where-Object { $_.class -eq $className } | Group-Object { $_.properties.$keyProperty } | ForEach-Object { $_.Group[0] }
$uniqueObjects | ConvertTo-Json -Depth 10 | Set-Content $exportFile

Write-Host "Backup concluído em $exportFile"
Add-Content $logFile "Backup exportado para $exportFile"
