#!/bin/bash

function ctrl_c(){
  echo -e "\n[+] Saliendo...\n"
  exit 1 # Codigo estado erroneo
}

# Ctrl+C
trap ctrl_c INT

# Ocultar cursor
tput civis

for port in $(seq 1 65535); do
  (echo '' > /dev/tcp/127.0.0.1/$port) 2>/dev/null && echo "[+] Port $port - OPEN" & # Hilo de ejecucion
done; wait # Espera a que los hilos finalicen

# Mostrar cursor
tput cnorm
