#!/usr/bin/env bash

# ##############################################################################
#
# DESCRIPCIÓN DEL SCRIPT
#
#  @author    Óscar Novás
#  @version   v1.0.0
#  @license   GNU/GPL v3+
# ##############################################################################


################################################################################
# CONFIGURACIÓN DEL SCRIPT.
################################################################################


# Cierro el script en caso de error.
set -e

# Colores.
R="\e[0m"  # reset
Y="\e[33m" # amarillo

# Control de tiempo de ejecución.
START=$(date +%s)

# Número mínimo de parámetros.
NUM_PARAMS=1

# Ubicación del script.
BASEDIR=$(dirname "$0")

# Variables para almacenar los parámetros:
PARAM_1=''


################################################################################
# FUNCIONES.
################################################################################


# Lee archivo de configuración.
function load_env() {
  ENV_FILE="${BASEDIR}/.env"
  if [ ! -f "${ENV_FILE}" ]; then
    clear
    echo "
-------------------------------------------------------------------------------
 No existe el archivo de variables de entorno (.env).
-------------------------------------------------------------------------------
    "
    exit 1
  else
    source "$(echo ${ENV_FILE})"
  fi
}

# Muestra la cabecera de algunas respuestas del script.
function show_header() {
  echo -e "
 +-----------------------------------------------------------------------------+
 |                                                                             |
 |                       ${Y}OscarNovas.com - for developers${R}                       |
 +-----------------------------------------------------------------------------+
  "
}

# Muestra la ayuda del script.
function show_usage() {
  clear
  show_header
  echo -e "
    Sintaxis del script:
      $0 [argumentos]

    Lista de parámetros/argumentos aceptados:
      ${Y}-h / --help${R}                  Muestra la ayuda del script.

  "
}

# Mensaje de finalización del script.
function show_bye() {
  # Calculo el tiempo de ejecución y muestro mensaje de final del script.
  END=$(date +%s)
  RUNTIME=$((END-START))

  clear
  echo "
 Tiempo de ejecución: ${RUNTIME}s
-------------------------------------------------------------------------------
  "
  exit 0
}

# Abre la carpeta actual en VSCode.
function open_vscode() {
  echo " "
  read -r -p "¿Deseas abrir el proyecto en VSCode [n]?: " ABRIR_VSCODE
  ABRIR_VSCODE=${ABRIR_VSCODE:-n}

  if [ "$ABRIR_VSCODE" == "y" ]; then
    if command -v code &> /dev/null
    then
      code .
    else
      echo '
 No se puede abrir el proyecto: No se encuentra VSCode.
-------------------------------------------------------------------------------
'
      exit 1
    fi
  fi
}

# Comprueba si el usuario que ejecuta el script es el super usuario.
function check_su() {
  if [[ "$EUID" -ne 0 ]]; then
    show_usage
    exit 1
  fi
}

# Comprueba el número de parámetros.
function check_num_params() {
  if [ $# -ne $NUM_PARAMS ]; then
    show_usage
    exit 2
  fi
}

# INFO: Modificar según los parámetros que necesite el script.
# Comprueba si se ha pasado el parámetro para mostrar la ayuda.
function get_params() {
  while [ $# -gt 0 ]; do
    case "$1" in

      --param1=*)
          PARAM_1="${1#*=}"
          ;;

      --help | -h)
        show_usage
        exit 0
        ;;

      *)
        show_usage
        exit 1
    esac
    # Elimino el argumento y paso al siguiente:
    shift
  done
}


################################################################################
# COMPROBACIONES PREVIAS.
################################################################################


check_su
check_num_params "$@"


################################################################################
# CUERPO PRINCIPAL DEL SCRIPT.
################################################################################


# Obtengo los posibles parámetros:
get_params "$@"

show_bye