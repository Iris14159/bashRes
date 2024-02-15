# Tareas Cron
Enlace de ayuda: https://www.site24x7.com/es/tools/crontab/cron-generator.html  
Las tareas cron son tareas que se ejecutan en intervalos de tiempo definidos.
Estas se encuentran en la carpeta **/etc/cron.d**.  
La sintaxis es simple pero puede ser algo compleja de comprender. Consiste de 5 espacios. Cada uno representado por un conjunto de tiempo diferente.  
\* \* \* \* \*  
minuto / hora / dia / mes / semana  

Cada asterisco contenmpla cada uno de los elementos de su posición; el ejemplo anterior dice que la tarea se va a ejecutar:
* Todos los minutos
* Todas las horas
* Todos los dias
* Todos los meses
* Todas las semanas  
_En resumen, se ejecutaria cada minuto_

5 * * * *   : Al minuto 5 de todas las horas.  
\* 14 * * *  : A las 2 de la tarde todos los dias.  
7 3 * * *   : A las 3:07am todos los dias.  


Cuando agregamos \*/ antes de un número hace refencia a por ejemplo: \*/5 cada 5, \*/14 cada 14... etc.

\*/5 * * * *    : Cada 5 minutos.  
\* \*/14 * * *   : Cada 14 horas.  
\*/7 \*/3 * * *  : Cada 7 minutos, cada 3 horas.  


