# Inyecciones en formato paginado
Es posible declarar variables con la palabra reservada **set**, esto puede funcionar al entrar en el modo paginado por un "more" entrando al modo visual con "v", un ejemplo seria:
* :set shell=/bin/bash
* :shell  
Esto nos entregaría una bash  

# inyecciones por ssh

Al conectarte por ssh, puede forzar a meter un comando en la misma linea, un ejemplo seria:  
* ssh usuario@IP -p 2222 bash  
Esto nos entregaria una bash
