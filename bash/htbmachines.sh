#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# Global variables
main_url="https://htbmachines.github.io/bundle.js"


#ctrl_c
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

#ctrl_c
trap ctrl_c INT

# Help function
function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}"
  echo -e "\t${purpleColour}u)${endColour} ${grayColour}Descargar o actualizar archivos necesarios.${endColour}"
  echo -e "\t${purpleColour}m)${endColour} ${grayColour}Buscar por nombre de maquina.${endColour}"
  echo -e "\t${purpleColour}i)${endColour} ${grayColour}Buscar por direccion IP.${endColour}"
  echo -e "\t${purpleColour}d)${endColour} ${grayColour}Buscar por dificultad de una maquina.${endColour}"
  echo -e "\t${purpleColour}d)${endColour} ${grayColour}Buscar por el sistema operativo.${endColour}"
  echo -e "\t${purpleColour}s)${endColour} ${grayColour}Buscar por skill.${endColour}"
  echo -e "\t${purpleColour}y)${endColour} ${grayColour}Obtener link de resolucion de la maquina en youtube.${endColour}"
  echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar este panel de ayuda.${endColour}\n"
}

# Search Machine function
function searchMachine(){
  machineName="$1"

  machineName_checker="$(cat bundle.js| awk "/name: \"$machineName\"/,/resuelta/" | tr -d '"' | tr -d ',' | sed "s/^ *//" | grep -vE "id:|sku:|resuelta:")"

  if [ "$machineName_checker" ]; then
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Listando las propiedades de la maquina${endColour} ${blueColour}$machineName${endColour}${grayColour}:${endColour}\n"
    cat bundle.js| awk "/name: \"$machineName\"/,/resuelta/" | tr -d '"' | tr -d ',' | sed "s/^ *//" | grep -vE "id:|sku:|resuelta:"
    echo -e "\n"
  else
    echo -e "\n${redColour}[!] La maquina indicada no existe.${endColour}\n"
  fi
}

# Update files function
function updateFiles(){
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando archivos necesarios...${endColour}"
    curl -s -X GET $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Archivos descargados.${endColour}\n"
    tput cnorm
  else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comprobando actualizaciones...${endColour}"

    curl -s -X GET $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_temp_value="$(md5sum bundle_temp.js | awk '{print $1}')"
    md5_original_value="$(md5sum bundle.js | awk '{print $1}')"

    if [ "$md5_temp_value" == "$md5_original_value" ] ; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}No hay actualizaciones pendientes.${endColour}\n"
      rm bundle_temp.js
    else
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se han detectado actualizaciones disponibles.${endColour}"
      sleep 2
      rm bundle.js && mv bundle_temp.js bundle.js
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Los archivos han sido actualizados.${endColour}\n"
    fi

    tput cnorm
  fi
}

# Search IP function 
function searchIP(){
  ipAddres=$1
  machineName="$(cat bundle.js | grep "ip: \"$ipAddres\"" -B 3 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
  if [ "$machineName" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La maquina correspondiente para la IP${endColour} ${blueColour}$ipAddres${endColour} ${grayColour}es${endColour} ${purpleColour}$machineName${endColour}${grayColour}.${endColour}\n"
    # searchMachine $machineName
  else
    echo -e "\n${redColour}[!] La direccion IP proporcionada no existe.${endColour}\n"
  fi
}

# Get Youtube Link Function
function getYoutubeLink(){
  machineName="$1"
  
  youtubeLink="$(cat bundle.js| awk "/name: \"$machineName\"/,/resuelta/" | tr -d '"' | tr -d ',' | sed "s/^ *//" | grep -vE "id:|sku:|resuelta:" | grep "youtube" | awk 'NF{print $NF}')"
  if [ $youtubeLink ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Link de la resolucion de la maquina:${endColour} ${blueColour}$youtubeLink${endColour}\n"
  else
    echo -e "\n${redColour}[!] La maquina proporcionada no existe.${endColour}\n"
  fi
}

# get machine difficulty function
function getMachinesDifficulty(){
  difficulty=$1
  machines="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$machines" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Mostrando maquinas de dificultad${endColour} ${blueColour}$difficulty${endColour}${grayColour}.${endColour}"
    cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    echo -e "\n"
  else
    echo -e "\n${redColour}[!] La dificultad indicada no existe.${endColour}\n"
  fi
}

# get OS Machines Function
function getOSMachines(){
  os=$1
  os_results="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$os_results" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Mostrando maquinas${endColour} ${blueColour}$os${endColour}${grayColour}:${endColour}"
    cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    echo -e "\n"
  else
    echo -e "\n${redColour}[!] El sistema operativo no existe.${endColour}\n"
  fi
}

# Get OS Difficulty Machine Function
function getOSDifficultyMachines(){
  difficulty=$1
  os=$2
  check_results="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$check_results" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando maquinas${endColour} ${blueColour}$os${endColour} ${grayColour}de dificultad${endColour} ${blueColour}$difficulty${endColour}${grayColour}.${endColour}"
  
    cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    echo -e "\n"
  else
    echo -e "\n${redColour}[!] Se ha indicado una dificultad o sistema operativo incorrecto.${endColour}\n"
  fi
}

# Get Skill Function
function getSkill(){
  skill="$1"
  check_skill="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$check_skill" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Maquinas con la skill${endColour} ${blueColour}$skill${endColour}${grauColour}:${endColour}"
    cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    echo -e "\n"
  else
    echo -e "\n${redColour}[!] No se ha encontrado ninguna maquina con la skill indicada.${endColour}\n"
  fi
}

# Indicadores
declare -i parameter_counter=0

# Comodin
declare -i comodin_difficulty=0
declare -i comodin_os=0

# Para agregar parametros al script
# Desclaramos arg que va a iterar en cada uno de los parametros
while getopts "m:ui:y:d:o:s:h" arg; do # m es un parametro que recibe argumentos, por eso lleva ":" y h que corresponde a 'help' no necesita argumentos por eso no lleva ":"
  case $arg in # Cada parametro debe cerrarse en doble ";;" 
    m) machineName="$OPTARG"; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddres="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; comodin_difficulty=1; let parameter_counter+=5;;
    o) os="$OPTARG"; comodin_os=1; let parameter_counter+=6;;
    s) skill="$OPTARG"; let parameter_counter+=7;;
    h) ;;
  esac
done # Cierra el bucle while

if [ $parameter_counter -eq 1 ]; then 
    searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAddres
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  getMachinesDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getOSMachines $os
elif [ $parameter_counter -eq 7 ]; then
  getSkill "$skill" # Las comillas permiten recibir argumentos separados por espacios: ./htbmachines.sh -s "Active Directory"
elif [ $comodin_difficulty -eq 1 ] && [ $comodin_os -eq 1 ]; then
  getOSDifficultyMachines $difficulty $os
else
  helpPanel
fi
