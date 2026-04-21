#region functions

#endregion functions

#region Variables


# Variables
$gitRepo = "https://github.com/pcbogota/web-pcb.git"
$nodejspath = "D:\devTools\nodejs\node-v24.15.0-win-x64"
$nodejsexec = Join-Path $nodejspath "node.exe"

#endregion Variables

###########################
######## Test area ########
###########################

$moduleName = "PCB-GitUtils"
$modulePath = "$env:ProgramFiles\WindowsPowerShell\Modules\$moduleName"
New-Item -ItemType Directory -Force -Path $modulePath  | Out-Null
$psm1Content = @'
function gitup {
    param(
        [string]$message
    )

    while([string]::IsNullOrEmpty($message)){
        Write-host "El mensaje no puede estar vacío. Escribe un mensaje y presiona [Enter]" -ForegroundColor Yellow
        $message = Read-Host
    }

    write-host "Mensaje: $message"
    git add .
    git commit -m $message
    git pull origin main --rebase
    git push origin main
}
Set-Alias gup gitup
Export-ModuleMember -Function gitup -Alias gup
'@

$psm1Content | Out-File -FilePath "$modulePath\$moduleName.psm1" -Encoding Unicode
New-ModuleManifest -Path "$modulePath\$moduleName.psd1" -RootModule "$moduleName.psm1" -Author "PCBogota" -Description "Modulo para alias de Git"

Import-Module $moduleName -Force
exit

###############################
######## END! Test area #######
###############################

#region Execution
#############################################
######## Ejecución de la instalación ########
Clear-Host

# Verificación de rutas requeridas
if (-not (Test-Path $nodejsexec)) {
	Write-Host "No se encuentra la ruta de node.js. no se puede continuar hasta verificarla" -ForegroundColor Red
	Write-Host "Ruta actual requerida:    $nodejsexec" -ForegroundColor Yellow
	Pause
	exit
}

# --- Git options ---

# agregar el origin al repositorio (por precaución)
git remote add origin $gitRepo *> $null | Out-Null


# agregar upsetream para usar solo `git push` ó `git pull --rebase`.
git branch --set-upstream-to=origin/main main

# generar el comando (alias) para subir el proyecto a github

# generar profile.ps1 para que la consola de pwoershel se vea rara🤪😁😬😰😱
$defaultProfilePath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\profile.ps1"





# agregar node.js al path
$currentPathArray = [Environment]::GetEnvironmentVariable("Path", "Machine") -split ";"
$nodePathClean = $nodejsPath.TrimEnd('\')
if ($currentPathArray -notcontains $nodePathClean) {
	Write-Host "Agregando la ruta '$nodejspath' al `$PATH"
	$env:Path = "$nodePathClean;" + $env:Path
	[Environment]::SetEnvironmentVariable("Path", "$nodePathClean; " + $env:Path, "Machine")
} else {
	Write-Host "Ya existe en `$PATH la ruta $nodejspath" -ForegroundColor cyan
}


# FASE 2
# El Almacén de Módulos (Caché Offline)
# Debes mover la carpeta donde Node guarda lo que descarga a una ruta que no esté en C:\Users\AppData (porque esa se borra al reinstalar Windows).
# El archivo .npmrc: Crearemos un archivo de configuración que le diga a Node: "Busca primero en este disco duro antes de preguntar en internet".

# FASE 3 La Estructura de Vite (Pseudo-instalación)
# Vite no es un programa que se instala, es un conjunto de scripts.
# Descarga en el periodo "Online": Crearemos un proyecto base mientras tengas internet.
# Congelamiento: Una vez descargado, la carpeta node_modules es tu tesoro. Si la copias tal cual, funcionará offline para siempre en ese proyecto porque contiene todos los ejecutables necesarios para compilar el sitio.

# Fase 4: Vercel CLI (El emulador)
# Vercel CLI es lo más complejo para tener offline porque se actualiza mucho.
# Instalación Global Portable: Lo instalaremos de forma que el ejecutable de Vercel viva dentro de tu carpeta de herramientas (C:\DevTools), no en los archivos temporales de Windows.
# Comando vercel dev: Este comando crea un servidor local que imita a Vercel. Si tienes tus archivos de la /api y tu index.html, este comando los unirá sin necesidad de subir nada a la nube.

Write-Host "" # separador final de ejecución
#endregion Execution
