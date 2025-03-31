#!/bin/bash
#Creacipon de usuario para firma electronica
# 2025-03-18
# Crea usuarios
/usr/sbin/useradd -m marco
/usr/sbin/useradd -m cristian
/usr/sbin/useradd -m david
# Asigna claves a los usuarios
echo "marco:marco2k25" | sudo chpasswd
echo "cristian:cristian2k25" | sudo chpasswd
echo "david:david2k25" | sudo chpasswd
#Agresa usuarios a grupo para suoders
/usr/sbin/usermod -aG wheel marco
/usr/sbin/usermod -aG wheel cristian
/usr/sbin/usermod -aG wheel david
