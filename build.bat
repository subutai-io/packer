:: Windows batch script for building Hyper-V boxes (Vagrant).
@echo off

:: Packer Hyper-V box build json file
set template=template.json

FOR %%A IN (xenial) DO GOTO=%%A

:xenial
:: Clean up boxes and log
del /s /q /f *.box 2>nul
del /s /q /f *.log 2>nul
rd /q /s "output-hyperv-iso" 2>nul
del ".\xenial\hyperv\%template%" 2>nul

:: Generate template.json file.
jsonnet ".\xenial\hyperv\template.jsonnet" > ".\xenial\hyperv\%template%"

if exist ".\xenial\hyperv\%template%" (
    packer validate ".\xenial\hyperv\%template%" 2>nul
    if errorlevel 1 (
      echo Packer validation error %errorlevel%
      exit /b %errorlevel%
    ) 
   
    packer build -on-error=ask -except=null ".\xenial\hyperv\%template%"
    if errorlevel 1 (
      echo "[xenial][ERROR] Aborting builds due to xenial build failure."
      echo "build line was:"
      echo "packer build -on-error=ask -except=null xenial/hyperv/template.json"
      exit /b %errorlevel%
    )
    vagrant box add --force subutai/xenial xenial-*.box    
) else (
    ECHO "Can't generate .\xenial\hyperv\%template% file"
    ECHO "If you don't have jsonnet: "
    ECHO "Please try this. Build jsonnet from here https://github.com/google/go-jsonnet and add jsonnet.exe path to Environment variable."
)

goto end 2>nul