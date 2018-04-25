@echo off
:: Windows batch script for building Hyper-V boxes (Vagrant).

:: Packer Hyper-V box build json file
set template="template.json"

FOR %%A IN (xenial) DO GOTO=%%A

:xenial
cd .\xenial\hyperv

:: Clean up boxes and log
del /s /q /f *.box 2>nul
del /s /q /f *.log 2>nul
rd /q /s "output-xenial-hyperv" 2>nul
del %template% 2>nul

:: Generate template.json file. Please build jsonnet from here https://github.com/google/go-jsonnet and add jsonnet.exe path to Envirotnment variable.
:: TODO check jsonnet command exist
jsonnet "template.jsonnet" > "%template%"

if exist %template% (
    packer validate %template%
    if errorlevel 1 (
      echo Packer validateion error %errorlevel%
      exit /b %errorlevel%
    ) 
    packer build -on-error=ask -except=null %template% 
    
) else (
    ECHO "Can't generate %template% file"
)
:: Go to back base directory
cd ..\..
goto end 2>nul