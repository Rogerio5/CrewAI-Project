Write-Host "=== Enviando relatório por Gmail para múltiplos destinatários ==="

# Caminho do PDF
$pdfPath = ".\results\relatorio-final.pdf"

# Configurações de envio
$from = "seuemail@gmail.com"        # seu Gmail
$to = @("destinatario1@example.com", "destinatario2@example.com", "destinatario3@example.com")  # lista de e-mails
$subject = "Relatório de Usuários Weaviate"
$body = "Segue em anexo o relatório consolidado em PDF."
$smtpServer = "smtp.gmail.com"
$smtpPort = 587

# Credenciais (vai pedir usuário/senha do Gmail)
$cred = Get-Credential

# Enviar e-mail para todos os destinatários
Send-MailMessage -From $from -To $to -Subject $subject -Body $body `
    -SmtpServer $smtpServer -Port $smtpPort -UseSsl `
    -Credential $cred -Attachments $pdfPath

Write-Host "=== Relatório enviado para todos os destinatários via Gmail ==="
