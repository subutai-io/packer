:: Windows batch script for building Hyper-V boxes (Vagrant).
@echo off

:: Packer Hyper-V box build json file
set template=template.json

FOR %%B IN (stretch) DO (
  :: Clean up boxes and log
  del /s /q /f *.box 2>nul
  del /s /q /f *.log 2>nul
  rd /q /s "output-hyperv-iso" 2>nul
  del ".\%%B\hyperv\%template%" 2>nul

  :: Generate template.json file.
  jsonnet ".\%%B\hyperv\template.jsonnet" > ".\%%B\hyperv\%template%"

  if exist ".\%%B\hyperv\%template%" (
      packer validate ".\%%B\hyperv\%template%" 2>nul
      if errorlevel 1 (
        echo Packer validation error %errorlevel%
        exit /b %errorlevel%
      ) 
    
      packer build -on-error=ask -except=null ".\%%B\hyperv\%template%"
      if errorlevel 1 (
        echo "[%%B][ERROR] Aborting builds due to %%B build failure."
        echo "build line was:"
        echo "packer build -on-error=ask -except=null %%B/hyperv/template.json"
        exit /b %errorlevel%
      )
      vagrant box add --force subutai/%%B %%B-*.box    
  ) else (
      ECHO "Can't generate .\%%B\hyperv\%template% file"
      ECHO "If you don't have jsonnet: "
      ECHO "Please try this. Build jsonnet from here https://github.com/google/go-jsonnet and add jsonnet.exe path to Environment variable."
  )
)