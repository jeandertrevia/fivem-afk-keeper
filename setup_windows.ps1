# =============================================================
#  FiveM AFK Keeper - Setup Windows
#  Instala Python, Claude Code (Cursor) e prepara o projeto
# =============================================================

$ErrorActionPreference = "Stop"

function Print-Step($msg) {
    Write-Host "`n>> $msg" -ForegroundColor Cyan
}

function Print-OK($msg) {
    Write-Host "   [OK] $msg" -ForegroundColor Green
}

function Print-Warn($msg) {
    Write-Host "   [!]  $msg" -ForegroundColor Yellow
}

# -------------------------------------------------------------
# 1. Verificar execucao como Administrador
# -------------------------------------------------------------
Print-Step "Verificando permissoes..."
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "`n  Execute este script como Administrador (clique direito > Executar como administrador)" -ForegroundColor Red
    exit 1
}
Print-OK "Rodando como administrador"

# -------------------------------------------------------------
# 2. Instalar Python via winget (se nao tiver)
# -------------------------------------------------------------
Print-Step "Verificando Python..."
$pythonPath = (Get-Command python -ErrorAction SilentlyContinue)?.Source

if ($pythonPath) {
    $pyVersion = python --version
    Print-OK "Python ja instalado: $pyVersion"
} else {
    Print-Warn "Python nao encontrado. Instalando via winget..."
    winget install --id Python.Python.3.12 --source winget --accept-package-agreements --accept-source-agreements
    # Recarregar PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
    Print-OK "Python instalado"
}

# -------------------------------------------------------------
# 3. Instalar Node.js (necessario para Claude Code)
# -------------------------------------------------------------
Print-Step "Verificando Node.js..."
$nodePath = (Get-Command node -ErrorAction SilentlyContinue)?.Source

if ($nodePath) {
    $nodeVersion = node --version
    Print-OK "Node.js ja instalado: $nodeVersion"
} else {
    Print-Warn "Node.js nao encontrado. Instalando via winget..."
    winget install --id OpenJS.NodeJS.LTS --source winget --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
    Print-OK "Node.js instalado"
}

# -------------------------------------------------------------
# 4. Instalar Claude Code CLI
# -------------------------------------------------------------
Print-Step "Instalando Claude Code..."
$claudePath = (Get-Command claude -ErrorAction SilentlyContinue)?.Source

if ($claudePath) {
    Print-OK "Claude Code ja instalado: $(claude --version)"
} else {
    npm install -g @anthropic-ai/claude-code
    Print-OK "Claude Code instalado"
}

Print-Warn "Para usar Claude Code no Cursor:"
Print-Warn "  1. Abra o Cursor"
Print-Warn "  2. Abra o terminal integrado (Ctrl + ``)"
Print-Warn "  3. Execute: claude"
Print-Warn "  4. Siga o login com sua conta Anthropic"

# -------------------------------------------------------------
# 5. Criar .venv e instalar dependencias do projeto
# -------------------------------------------------------------
Print-Step "Configurando ambiente virtual do projeto..."

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

if (-not (Test-Path ".venv")) {
    python -m venv .venv
    Print-OK ".venv criado"
} else {
    Print-OK ".venv ja existe"
}

Print-Step "Instalando dependencias (requirements.txt)..."
.\.venv\Scripts\pip install -r requirements.txt
Print-OK "Dependencias instaladas"

# -------------------------------------------------------------
# Resumo final
# -------------------------------------------------------------
Write-Host "`n=============================================" -ForegroundColor Magenta
Write-Host "  Setup concluido!" -ForegroundColor Magenta
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Para rodar o projeto:" -ForegroundColor White
Write-Host "    .\.venv\Scripts\python main.py" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Para usar Claude Code:" -ForegroundColor White
Write-Host "    claude" -ForegroundColor Yellow
Write-Host ""
