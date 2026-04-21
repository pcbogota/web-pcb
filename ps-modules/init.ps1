# Este archivo es el mismo que se puede usar en $PROFILE de vscode

function Get-CenteredText {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Text,
		[switch]$SidePadding
	)

	$padding = ' ' * [math]::Max(0, (([console]::WindowWidth - (($Text.length) + 1)) / 2))
	if ($SidePadding) { return $padding } else { return "$padding$text$padding" }

}

function Write-Logo {
	<#
	.SYNOPSIS
		Imprime un logo personalizado en la consola de PowerShell.

	.DESCRIPTION
		Esta función genera e imprime un logo en la consola, utilizando caracteres especiales y códigos de escape ANSI para colores y formatos.  El logo incluye el nombre "Camilo Salazar (ChyBeat)", el año actual y un mensaje de copyright.

	.EXAMPLE
		PS> Write-Logo

	.NOTES
		Autor: Camilo Salazar
		Fecha de creación: 2025-02-07
		Fecha de modificación: 2025-12-05
		Versión: 1.0.2.a - (Simplificado)
	#>

	$c = $([char]9608)
	$d = $([char]9612)
	$i = $([char]9616)
	$p = $([char]0x25CF)
	$logoWide = 93
	$cl = @{
		ty = $global:TerminalColor.txt.orange
		tr = $global:TerminalColor.txt.red
		tw = $global:TerminalColor.txt.white
	}

	if ($w10) {	$c = $([char]9209) }

	if ($psISE) {
		$padd = $(Get-CenteredText -Text 'PCBOGOTA.COM' -SidePadding)
		Write-Host "`n`n$($padd)P" -ForegroundColor Yellow -NoNewline
		Write-Host "C" -ForegroundColor Red -NoNewline
		Write-Host "Bogota.com`n`n" -ForegroundColor White
		return
	} else {
		$padd = Get-CenteredText -Text (" " * $logoWide) -SidePadding
	}
	$Logo_P = $($cl.ty); $Logo_C1 = $($cl.tr); $Logo_B = $($cl.tw); $Logo_o1 = $($cl.tw); $Logo_G = $($cl.tw); $Logo_o2 = $($cl.tw); $Logo_T = $($cl.tw); $Logo_A = $($cl.tw); $Logo_DOT = $($cl.tw); $Logo_C2 = $($cl.tw); $Logo_o3 = $($cl.tw); $Logo_M = $($cl.tw); $logo = "`n$($padd)$($Logo_P)$c$c$c$c$c$c$c$c $($Logo_C1)$c$c$c$c$c$c$c$c`n"
	$logo += "$($padd)$($Logo_P)$c$c    $c$c $($Logo_C1)$c$c    $c$c $($Logo_B)$c$c$c$c$c$c$d $($Logo_o1)$c$c$c$c$c$c$c $($Logo_G)$c$c$c$c$c$c$c $($Logo_o2)$c$c$c$c$c$c$c $($Logo_T)$c$c$c$c$c$c $($Logo_A)$c$c$c$c$c$c$c   $($Logo_C2)$c$c$c$c$c$c $($Logo_o3)$c$c$c$c$c$c$c $($Logo_M)$c$c$c$c$d$i$c$c$c$c`n"
	$logo += "$($padd)$($Logo_P)$c$c    $c$c $($Logo_C1)$c$c       $($Logo_B)$c$c   $c$d $($Logo_o1)$c$c   $c$c $($Logo_G)$c$c      $($Logo_o2)$c$c   $c$c   $($Logo_T)$c$c   $($Logo_A)$c$c   $c$c   $($Logo_C2)$c$c     $($Logo_o3)$c$c   $c$c $($Logo_M)$c$c  $c$c  $c$c `n"
	$logo += "$($padd)$($Logo_P)$c$c$c$c$c$c$c$c $($Logo_C1)$c$c       $($Logo_B)$c$c$c$c$c$c$c $($Logo_o1)$c$c   $c$c $($Logo_G)$c$c  $c$c$c $($Logo_o2)$c$c   $c$c   $($Logo_T)$c$c   $($Logo_A)$c$c$c$c$c$c$c   $($Logo_C2)$c$c     $($Logo_o3)$c$c   $c$c $($Logo_M)$c$c  $c$c  $c$c `n"
	$logo += "$($padd)$($Logo_P)$c$c       $($Logo_C1)$c$c    $c$c $($Logo_B)$c$c   $c$c $($Logo_o1)$c$c   $c$c $($Logo_G)$c$c   $c$c $($Logo_o2)$c$c   $c$c   $($Logo_T)$c$c   $($Logo_A)$c$c   $c$c   $($Logo_C2)$c$c     $($Logo_o3)$c$c   $c$c $($Logo_M)$c$c  $c$c  $c$c `n"
	$logo += "$($padd)$($Logo_P)$c$c       $($Logo_C1)$c$c$c$c$c$c$c$c $($Logo_B)$c$c$c$c$c$c$c $($Logo_o1)$c$c$c$c$c$c$c $($Logo_G)$c$c$c$c$c$c$c $($Logo_o2)$c$c$c$c$c$c$c   $($Logo_T)$c$c   $($Logo_A)$c$c   $c$c $($Logo_DOT)$p $($Logo_C2)$c$c$c$c$c$c $($Logo_o3)$c$c$c$c$c$c$c $($Logo_M)$c$c  $c$c  $c$c `n"
	$logo += "$([char]0x1b)[0m"
	Write-Host $logo
}

$global:TerminalColor = [PSCustomObject]@{
	txt = [PSCustomObject]@{
		orange = "$([char]0x1b)[38;5;214m" #Texto naranja P de PCBogota
		red    = "$([char]0x1b)[38;5;196m" #Texto rojo
		white  = "$([char]0x1b)[38;5;15m" #Texto Blanco
	}
}

Clear-Host
Write-Logo
$terminal = if ($PROFILE -match "VSCode_profile") { "Powershell Extension Terminal" }else { "Default Terminal" }
Write-Host (Get-CenteredText -Text "VSCode $Terminal") -ForegroundColor Cyan

$testGit = git rev-parse --is-inside-work-tree 2>$null
if ((Test-Path (Join-Path (Get-Location) ".git")) -or $testGit) {
	$sshPath = "$env:USERPROFILE\.ssh"
	if (-not (Test-Path "$sshPath\known_hosts")) {
		Write-Host "`nConfigurando conexión SSH a github con conexion por primera vez." -ForegroundColor Yellow
		Write-Host "- Permita la conexión ingresando 'yes'" -ForegroundColor Yellow
		Write-Host "- Luego ingrese la contraseña para la llave que se le pide" -ForegroundColor Yellow
		ssh -T git@github.com
		if (Test-Path "$sshPath\known_hosts.old") {
			Remove-Item -Path "$sshPath\known_hosts.old" -Force
		}
		Write-Host "Es posible que necesite reingresar la contraña a continuación" -ForegroundColor Yellow
	}

	$service = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
	if ($service.StartType -ne 'Manual') {
		Set-Service -Name ssh-agent -StartupType Manual
	}

	if ($service.Status -ne 'Running') {
		Start-Service ssh-agent
	}

	$fingerprint = ssh-keygen -lf $env:USERPROFILE\.ssh\github_pcbog
	$loaded = ssh-add -l 2>$null
	if ($loaded.Trim() -notmatch [regex]::Escape($fingerprint.Trim())) {
		Write-Host "Conección a SSH GitHub (presiona [Enter] para omitir...)`n" -ForegroundColor Yellow
		ssh-add "$env:USERPROFILE\.ssh\github_pcbog"
	}
	Write-Host ""
}
