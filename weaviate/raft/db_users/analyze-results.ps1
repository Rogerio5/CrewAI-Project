Write-Host "=== Relatório dos resultados ==="

# Ler resultado básico
$basic = Get-Content .\results\resultado-basic.json -Raw | ConvertFrom-Json
Write-Host "`n--- Resultado Básico ---"
$basic.data.Get.User | Select-Object `
    @{Name="Nome";Expression={$_.nome}}, `
    @{Name="Email";Expression={$_.email}}, `
    @{Name="Idade";Expression={$_.idade}}, `
    @{Name="Documento";Expression={($_.documento | ForEach-Object { $_.text }) -join "; "}} `
    | Format-Table -AutoSize

# Exportar para CSV
$basic.data.Get.User | Select-Object `
    @{Name="Nome";Expression={$_.nome}}, `
    @{Name="Email";Expression={$_.email}}, `
    @{Name="Idade";Expression={$_.idade}}, `
    @{Name="Documento";Expression={($_.documento | ForEach-Object { $_.text }) -join "; "}} `
    | Export-Csv -Path .\results\relatorio-basic.csv -NoTypeInformation -Encoding UTF8

Write-Host "Relatório básico exportado para results/relatorio-basic.csv"

# Ler resultado avançado
$advanced = Get-Content .\results\resultado-advanced.json -Raw | ConvertFrom-Json
Write-Host "`n--- Resultado Avançado (idade > 30 e email contendo '@example.com') ---"
$advanced.data.Get.User | Select-Object `
    @{Name="Nome";Expression={$_.nome}}, `
    @{Name="Email";Expression={$_.email}}, `
    @{Name="Idade";Expression={$_.idade}}, `
    @{Name="Documento";Expression={($_.documento | ForEach-Object { $_.text }) -join "; "}} `
    | Format-Table -AutoSize

# Exportar para CSV
$advanced.data.Get.User | Select-Object `
    @{Name="Nome";Expression={$_.nome}}, `
    @{Name="Email";Expression={$_.email}}, `
    @{Name="Idade";Expression={$_.idade}}, `
    @{Name="Documento";Expression={($_.documento | ForEach-Object { $_.text }) -join "; "}} `
    | Export-Csv -Path .\results\relatorio-advanced.csv -NoTypeInformation -Encoding UTF8

Write-Host "Relatório avançado exportado para results/relatorio-advanced.csv"

Write-Host "`n=== Relatório concluído ==="
