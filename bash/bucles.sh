#!/bin/bash

echo "0016
D89C" | while read line; do echo "Leyendo la linea $line"; done

for line in $(echo "0016
  D89C"); do echo "[+] Mostrando el contenido $line"; done

echo "0016
D89C" | while read line; do echo "[+] Puerto $line -> $(echo "obase=10; ibase=16; $line" | bc) - OPEN"; done
