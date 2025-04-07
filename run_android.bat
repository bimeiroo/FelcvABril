@echo off
echo =========================================
echo    FELCV - Inicializando Aplicacion
echo =========================================
echo.

REM Verificar si Flutter está disponible
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Flutter no encontrado. Asegurate de que Flutter este instalado y en el PATH.
    goto :eof
)

echo Actualizando dependencias...
call flutter pub get

echo.
echo =========================================
echo    Dispositivos disponibles:
echo =========================================
call flutter devices

echo.
set /p device=Ingresa ID del dispositivo (deja en blanco para el predeterminado): 

if "%device%"=="" (
    echo Ejecutando aplicacion en dispositivo predeterminado...
    call flutter run
) else (
    echo Ejecutando aplicacion en dispositivo %device%...
    call flutter run -d %device%
)

echo.
echo Presiona cualquier tecla para salir...
pause >nul 