[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$release = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/SoftCreatR/warp-up/releases/latest"
$asset = $release.assets | Where-Object name -like *.zip
$destdir = "$home\apps\warp-up"
$zipfile = "$env:TEMP\$($asset.name)"

Write-Output "Downloading $($asset.name)"
Invoke-RestMethod -Method Get -Uri $asset.browser_download_url -OutFile $zipfile

Write-Output "Extracting to $destdir"
Expand-Archive -Path $zipfile -DestinationPath $destdir -Force
Remove-Item -Path $zipfile

$p = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User);
if (!$p.ToLower().Contains($destdir.ToLower()))
{
	Write-Output "Adding $destdir to your Path"
	
	$p += ";$destdir";
	[System.Environment]::SetEnvironmentVariable('Path',$p,[System.EnvironmentVariableTarget]::User);
	
	$Env:Path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ";" + $p
	
	Write-Output "Restart your consoles to refresh the Path env var."
}

Write-Output "Done! You can start it by executing the command 'warp-up'."
Start-Sleep -Seconds 5
