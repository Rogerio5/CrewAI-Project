Write-Host "=== Enviando relatório por e-mail ==="

# Caminho do PDF
$pdfPath = ".\results\relatorio-final.pdf"

# Configurações de envio
$from = "seuemail@example.com"
$to = "destinatario@example.com"
$subject = "Relatório de Usuários Weaviate"
$body = "Segue em anexo o relatório consolidado em PDF."
$smtpServer = "smtp.seuprovedor.com"
$smtpPort = 587

# Credenciais (vai pedir senha ao rodar)
$cred = Get-Credential

# Enviar e-mail
Send-MailMessage -From $from -To $to -Subject $subject -Body $body `
    -SmtpServer $smtpServer -Port $smtpPort -UseSsl `
    -Credential $cred -Attachments $pdfPath

Write-Host "=== Relatório enviado para $to ==="
