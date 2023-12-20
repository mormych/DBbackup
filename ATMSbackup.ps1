#Skrypt wykonujący automatyczny DUMP całej bazy danych MySQL

#Ustawiam katalog roboczy dla całego skryptu
Set-Location -Path ""

#Ustawiam dane do logowania dla skryptu
$path_to_config_file = ""


#Ustawiam katalog docelowy dla kopii zapasowej i ustawiam nazwe finalnego pilku
$backup_path=""


#Wykonuje kopie zapasową
$err = (mysqldump --defaults-file=$path_to_config_file --all-databases -r $backup_path) 2>&1
if (-Not ($err -eq $null)) 
{
    C:\RogerRCP\scripts\DBbackup\sender.ps1 1 $err 15 $PSCommandPath
    exit
} 

#Etap 2. Wykonuje dump sqlexpress
$User = "sa"
$PWord = ConvertTo-SecureString -String "" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$Database = ""
try 
{
    Backup-SqlDatabase -ServerInstance localhost -Database $Database -BackupAction Database -BackupFile "" -Credential $Credential
}
catch 
{
    C:\RogerRCP\scripts\DBbackup\sender.ps1 2 $_ 28 $PSCommandPath
    exit
}

#Etap 3. Wykonuje kopie zapasową pliku rcpEvents i nadpisuje 
Copy-Item "" -Destination "" -Force

#Kompresuje i tworze archiwum
$compress = @{
    Path = "", "", ""
    CompressionLevel = "Fastest"
    DestinationPath = ""
}

try 
{
    Compress-Archive @compress
}
catch 
{
    C:\RogerRCP\scripts\DBbackup\sender.ps1 3 $_ 48 $PSCommandPath
    exit
}

#Kopiuje na dysk zdalny
try
{
    Copy-Item "" -Destination ""
}
catch
{
    C:\RogerRCP\scripts\DBbackup\sender.ps1 7 $_ 59 $PSCommandPath
}
C:\RogerRCP\scripts\DBbackup\sender.ps1 0

#Czyszcze stare backupy
try
{
    C:\RogerRCP\scripts\DBbackup\cleaner.ps1
}
catch
{
    C:\RogerRCP\scripts\DBbackup\sender.ps1 6 $_ 70 ""
    exit
}