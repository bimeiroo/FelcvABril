#!/bin/bash

echo "========================================="
echo "    FELCV - Inicializando Aplicacion"
echo "========================================="
echo

# Verificar si Flutter está disponible
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter no encontrado. Asegurate de que Flutter este instalado y en el PATH."
    exit 1
fi

echo "Actualizando dependencias..."
flutter pub get

echo
echo "========================================="
echo "    Dispositivos disponibles:"
echo "========================================="
flutter devices

echo
read -p "Ingresa ID del dispositivo (deja en blanco para el predeterminado): " device

if [ -z "$device" ]; then
    echo "Ejecutando aplicacion en dispositivo predeterminado..."
    flutter run
else
    echo "Ejecutando aplicacion en dispositivo $device..."
    flutter run -d "$device"
fi

echo
echo "Presiona Enter para salir..."
read 