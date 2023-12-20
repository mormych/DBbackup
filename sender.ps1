param (
    $errorCode,
    $errorMsg,
    $errorLine,
    $errorScript
)
$password = ConvertTo-SecureString "" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("", $password)
If($errorCode -eq 0)
{
    $Body = "<p>Kopia ukończona</p><p>Kopia z dnia $(Get-Date) została wykonana"
    $Recepients = ""
    $Subject = "ATMS Kopia zapasowa wykonana"
}
If($errorCode -eq 1)
{
    $Body = "<p>Wystąpiły problemy z exportem bazy MySql.</p><p>Błąd: <b>$($errorMsg)</b></p><p>Linijka: <b>$($errorLine)</b></p><p>Skrypt: <b>$($errorScript)</b></p><p>Kopia nie została stworzona!</p>"
    $Recepients = ""
    $Subject = "ATMS Brak kopii zapasowej!"
}
If($errorCode -eq 2)
{
    $Body = "<p>Wystąpiły problemy z exportem bazy SQLEXPRESS.</p><p>Błąd: <b>$($errorMsg)</b></p><p>Linijka: <b>$($errorLine)</b></p><p>Skrypt: <b>$($errorScript)</b></p><p>Kopia nie została stworzona!</p>"
    $Recepients = ""
    $Subject = "ATMS Brak kopii zapasowej!"
}
If($errorCode -eq 3)
{
    $Body = "<p>Wystąpiły problemy z tworzeniem archiwum baz danych.</p><p>Błąd: <b>$($errorMsg)</b></p><p>Linijka: <b>$($errorLine)</b></p><p>Skrypt: <b>$($errorScript)</b></p><p>Kopia nie została stworzona!</p>"
    $Recepients = ""
    $Subject = "ATMS Brak kopii zapasowej!"
}
If($errorCode -eq 4)
{
    $Body = "<p>Skrypt cleaner zakończył działanie.</p><p>Brak usuniętych plików <b>*.zip</b></p>"
    $Recepients = ""
    $Subject = "ATMS Czyszczenie ukończone"
}
If($errorCode -eq 5)
{
    $Body = "<p>Skrypt cleaner usunął plik.</p><p>Został usunięty plik: $($errorMsg)</b></p>"
    $Recepients = ""
    $Subject = "ATMS Czyszczenie ukończone"
}
If($errorCode -eq 6)
{
    $Body = "<p>Skrypt ukończył działanie ale wystąpił problem z oczyszczaniem NAS.</p><p>Błąd: <b>$($errorMsg)</b></p><p>Linijka: <b>$($errorLine)</b></p><p>Skrypt: <b>$($errorScript)</b></p>"
    $Recepients = ""
    $Subject = "ATMS Kopia wykonana ale wystąpiły błędy"
}
If($errorCode -eq 7)
{
    $Body = "<p>Skrypt ukończył działanie ale wystąpił problem z kopiowaniem archiwum na NAS.</p><p>Błąd: <b>$($errorMsg)</b></p><p>Linijka: <b>$($errorLine)</b></p><p>Skrypt: <b>$($errorScript)</b></p><p>Kopia nie została przeniesiona!</p>"
    $Recepients = ""
    $Subject = "ATMS Kopia wykonana ale wystąpiły błędy"
}

$MailMessage = @{
        To = $Recepients
        From = ""
        Subject = $Subject
        Body =  $Body
        Smtpserver = ""
        BodyAsHtml = $true
        Encoding = "UTF8"
        Credential = $Cred
        UseSsl = $true
    }
Send-MailMessage @MailMessage