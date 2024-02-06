#!/bin/bash

function ctrl_c(){
  echo -e "\n[+] Saliendo...\n"
  exit 1 
}

# Ctrl + C
trap ctrl_c INT


first_file_name='data.gz'

descompressed_file_name="$(7z l data.gz | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"

7z x $first_file_name &>/dev/null

while [ $descompressed_file_name ]; do
  echo -e "\n[+] Nuevo archivo descomprimido: $descompressed_file_name"
  7z x $descompressed_file_name &>/dev/null
  descompressed_file_name="$(7z l $descompressed_file_name 2>/dev/null | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"
done
