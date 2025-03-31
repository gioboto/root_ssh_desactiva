#!/bin/bash

# Definir la interfaz local
localint="lo"

# Solicitar al usuario el nombre del archivo
read -p "Escriba el nombre del archivo en /etc/ (por ejemplo, sysctl.conf): " filename

# Verificar si el archivo existe
if [ ! -f "/etc/$filename" ]; then
    echo "El archivo /etc/$filename no existe. Creándolo..."
    #touch "/etc/$filename"
fi

# Obtener los nombres de las interfaces de red
interfaces=$(ip -o link show | awk -F': ' '{print $2}')

# Iterar sobre cada interfaz
for interfaz in $interfaces; do
    # Crear una cadena de letras basada en el nombre de la interfaz
    cadena_letras=$(echo $interfaz | sed 's/[^a-zA-Z]//g')

    # Comparar la interfaz actual con la interfaz local
    if [ "$interfaz" = "$localint" ]; then
        echo "Ignorando la interfaz local: $interfaz"
    else
        echo "Deshabilitando IPv6 para la interfaz: $interfaz"
        echo "net.ipv6.conf.$interfaz.disable_ipv6 = 1" >> "/etc/$filename"
    fi
done

#systemctl restart network.service
echo "Configuración completada. Revisa el archivo /etc/$filename. y ejecutar sysctl -p"
