#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Script debe ejecutarse como root!!"
    exit 1
fi

uid_zero_users=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)
count=$(echo "$uid_zero_users" | wc -l)

if [ "$count" -gt 1 ]; then
    echo -e "\033[1;31m[ALERTA] Se encontraron $count usuarios con UID=0:\033[0m"
    echo "$uid_zero_users"
    echo -e "\n\033[1;33mRecomendación: Elimina o cambia el UID de los usuarios no autorizados.\033[0m"
    exit 1
else
    echo -e "\033[1;32m[OK] Solo hay 1 usuario con UID=0:\033[0m"
    echo "$uid_zero_users"
fi

SSHD_CONFIG="/etc/ssh/sshd_config"

cp "$SSHD_CONFIG" "$SSHD_CONFIG.bak"

if grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
else
    echo "PermitRootLogin no" >> "$SSHD_CONFIG"
fi

systemctl restart sshd
systemctl status sshd --no-pager

echo ""
echo "Acceso SSH como root deshabilitado"
