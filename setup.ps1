Get-Content .env | foreach {
  $name, $value = $_.split('=')
  if ([string]::IsNullOrWhiteSpace($name) -or $name.Contains('#')) {
    continue
  }
  Set-Content env:\$name $value
}
$hosts="C:\Windows\System32\Drivers\etc\hosts"
$subDomains= "", "api.", "authelia.", "traefik."
foreach($domain in $subDomains)
{
    $str="172.0.0.1" + " " + $domain + $env:DOMAIN_NAME
    Write-Host $str
    # $result = Select-String $hosts -Pattern $str
    # if ([string]::IsNullOrWhiteSpace($result)){
        # Add-Content $hosts $str
    # }
}