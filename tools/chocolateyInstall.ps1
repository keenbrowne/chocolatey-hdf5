$hdf5 = "hdf5-1.8.15"
$hdf5Zip = Join-Path $env:Temp ($hdf5 + ".zip")
# Download the 64-bit or 32-bit version
Get-ChocolateyWebFile `
    -packageName 'hdf5' `
    -fileFullPath  "$hdf5Zip" `
    -url 'http://www.hdfgroup.org/ftp/HDF5/current/bin/windows/hdf5-1.8.15-patch1-win32-vs2013-shared.zip' `
    -url64bit 'http://www.hdfgroup.org/ftp/HDF5/current/bin/windows/hdf5-1.8.15-patch1-win64-vs2013-shared.zip'

# Unzip to a temporary folder 
$unzippedPath = Get-ChocolateyUnzip $hdf5Zip $env:Temp

# Find the path to the 32-bit or 64-bit installer
$installerDir = (Join-Path $unzippedPath "hdf5")
$installerFileName = $hdf5 + "-win64.msi"
if (($env:chocolateyForceX86) -or (Get-ProcessorBits 32)) {
    $installerFileName = $hdf5 + "-win32.msi"
} elseif (-not (Get-ProcessorBits 64)) {
    Write-Output "Trying 64-bit install on unidentified architecture."
}

# Run the installer
$installerPath = Join-Path $installerDir $installerFileName
Install-ChocolateyInstallPackage "hdf5" "msi" "/quiet" "$installerPath"
