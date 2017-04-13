[CmdletBinding()]
Param()

$ErrorActionPreference = 'Stop';

# Take care to avoid allowing this script to run with an invalid execution 
# policy as it can leave the machine in an unexpected state
$policy = Get-ExecutionPolicy
if (-not (($policy -eq "Unrestricted") -or `
          ($policy -eq "Bypass"))) {
    Write-Warning("Must be run with -ExecutionPolicy Bypass/Unrestricted")
    return
}

Set-ExecutionPolicy Unrestricted -Scope Process
Set-ExecutionPolicy Unrestricted -Scope CurrentUser

if (-not (Test-Path -PathType Container -Path "$env:ProgramData\chocolatey")) {
    Invoke-Expression ((New-Object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install git first so we can clone the repository itself
if (-not ($(choco list -lo) -like 'git*')) {
    Write-Verbose 'Installing git...'
    (choco install -r -y git) | Out-Null
    # Refresh the path within this shell
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

$repo = 'https://github.com/rrohrer/dotfiles.git'
$clone = "$env:HOMEPATH\dotfiles"

if (Test-Path -Path $clone) {
    Write-Verbose "Pulling from $repo..."
    cmd /c "cd $clone && git pull"
}
else {
    Write-Verbose "Cloning $repo into $clone..."
    git clone $repo $clone --recursive
}

Write-Verbose 'Upgrading existing packages...'
(choco upgrade -r -y all) | Out-Null

Write-Verbose "Installing packages from $clone\platform\windows\packages.config"
(choco install -r -y "$clone\platform\windows\packages.config") | Out-Null

choco list -lo

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

#if (-not (Test-Path -PathType Leaf -Path "$env:HOMEPATH\.gitconfig")) {
#    cmd /c mklink /H $env:HOMEPATH\.gitconfig $clone\Platform\Windows\.gitconfig
#}

$files_to_link = 
    ".ctags",
    ".vimrc"

foreach ($file in $files_to_link) {
    $source = "$clone\$file"
    $dest = "$env:HOMEPATH\$file"
    if (Test-Path -Path $dest) {
        Write-Warning('Creating hard link FAILED - delete file and try again')
        Write-Warning("    $dest")
    }
    else {
        cmd /c mklink /H $dest $source | Out-Null
    }
}

cmd /c mklink $env:HOMEPATH\vimfiles $env:HOMEPATH\.vim | Out-Null

Write-Verbose 'gvim +PlugInstall +qall'
gvim +PlugInstall +qall

#[Environment]::SetEnvironmentVariable("DOTFILES", "$env:HOMEPATH\.dotfiles", "User")

#cmd /c reg add 'HKCU\Software\Microsoft\Command Processor' /v AutoRun ^ /t REG_EXPAND_SZ /d $clone\Platform\Windows\setup-env.cmd /f
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\tools\mingw64\bin", [EnvironmentVariableTarget]::Machine)
