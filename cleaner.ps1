function Can-Delete-File
{
    param (
        $FileToCheck,
        $MinDate
    )
    If(-Not ($File -like "*.zip"))
    {
        return $false;
    }
    If((New-TimeSpan -Start ($FileToCheck).CreationTime -End $MinDate).Days -gt 0)
    {
        return $true;
    }
    Else 
    {
        return $false;
    }
}

#Ustawiam katalog roboczy dla całego skryptu
Set-Location -Path "" -ErrorAction Stop

$Files = Get-ChildItem
$MinDate = (Get-Date) - (New-TimeSpan -Days 7)
$NoDelete = $true;
Foreach($File in $Files)
{
    If(Can-Delete-File -FileToCheck $File -MinDate $MinDate)
    {
        Remove-Item $File.FullName
        $NoDelete = $false;
        C:\RogerRCP\scripts\DBbackup\sender.ps1 5 $File
    }
}

If($noDelete -eq $true)
{
    C:\RogerRCP\scripts\DBbackup\sender.ps1 4
}