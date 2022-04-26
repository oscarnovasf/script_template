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

# Control de tiempo de ejecución.
START=$(date +%s)

# Número mínimo de parámetros.
NUM_PARAMS=1


################################################################################
# FUNCIONES.
################################################################################


# Lee archivo de configuración.
function load_env() {
  if [ ! -f .env ]; then
    clear
    echo "
-------------------------------------------------------------------------------
 No existe el archivo de variables de entorno (.env).
-------------------------------------------------------------------------------
    "
    exit 1
  else
    source .env
  fi
}
# Muestra la cabecera de algunas respuestas del script.
function show_header() {
  echo "
 +-----------------------------------------------------------------------------+
 |                                                                             |
 |                       OscarNovas.com - for developers                       |
 +-----------------------------------------------------------------------------+
  "
}

# Muestra la ayuda del script.
function show_usage() {
  clear
  show_header
  echo "
    Sintaxis del script:
      $0 [argumentos]

    Lista de parámetros/argumentos aceptados:
      -h / --help                  Muestra la ayuda del script.

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

# Comprueba si se ha pasado el parámetro para mostrar la ayuda.
function check_help_param() {
  if [[ ( $* == "--help") || $* == "-h" ]]; then
    show_usage
    exit 0
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


################################################################################
# COMPROBACIONES PREVIAS.
################################################################################


check_su
check_num_params "$@"
check_help_param "$@"


################################################################################
# CUERPO PRINCIPAL DEL SCRIPT.
################################################################################


show_bye