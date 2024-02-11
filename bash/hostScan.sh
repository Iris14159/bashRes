#!/bin/bash

function ctrl_c(){
  echo -e "\n[+] Saliendo...\n"
  exit 1 # Codigo estado erroneo
}

# Ctrl+C
trap ctrl_c INT

base=$(ip a | grep "ens33" | tail -n 1 | awk '{print $2}' | awk '{print $1}' FS='/' | awk '{print $1,$2,$3}' FS='.' | tr ' ' '.' | sed 's/$/./')

for i in $(seq 1 254); do
  ping -c 1 "$base$i" &>/dev/null && echo "[+] $base$i - Activo" &
done; wait

# Tambien puede hacerse un:
# timeout 1 bash -c "ping -c IP &>/dev/null" && echo "[+] El host esta activo"
