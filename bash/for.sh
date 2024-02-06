#!/bin/bash
for i in $(seq 1 20); do echo -e "\n[+] Probando con $i: $(cat example | cut -d ' ' -f $i) \n" ; done
