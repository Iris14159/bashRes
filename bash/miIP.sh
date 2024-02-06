#!/usr/bin/bash

echo "Tu IP privada es: $(hostname -I | awk '{print $1}')"
