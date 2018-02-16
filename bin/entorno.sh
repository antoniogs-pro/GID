#!/bin/bash
####################################################################################
# Autor: Antonio González
# Proposito del script: 
# Fichero para pre-procesar y depurar ficheros CSV de líneas y caracteres no válidos
# Genera fichero ficheroatratar.csv
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado:
#  agregada variable para fichero de LOG
#  agregada variable para directorio de funciones y procedimientos genéricos
# Como usarlo
# echo "Como usarlo:  " . $0  "  OJO al punto para ejecutar en shell actual
####################################################################################
. ~/bin/.bash_aliases
#. ~/bin/keybsp.sh  # ver alias keybsp
# Variables de entorno impresindibles
export SIC=$HOME/SIC/Gestion_Identidad                 # Directorio  base
if [ "$SICSCRIPTS" == "" ]
then
export SICSCRIPTS=$SIC/BA  # Directorio para los script relacionados con mi trabajo
fi
export FUNPROC=$SIC/bin   # Directorio para mis funciones y procedimientos genéricos
export MISSCRIPTS=$SIC/mis_scripts   # Directorio para mis scripts
export TMPDIR=$HOME/tmp
export TmpDir=$HOME/tmp
export LOGDIR=$SIC/log			# Directorio para LOGs
export LogDir=$SIC/log
export LOGFILE=$LOGDIR/bitacora.log
export BASEPATH=$PATH
export OLDPATH=$PATH
export PATH=$PATH:$HOME/bin:$SIC/bin:$SICSCRIPTS
export XAUTHORITY=$HOME/.Xauthority
# Variables calculadas
export VPNstatus=off
export LLAVE=$(cat ~/.ssh/config | grep "IdentityFile" | cut -d " " -f2)
#
#
# Aliases y  Variables asociadas a Ordenes
. $FUNPROC/ordenes.sh      # 
#
### Funciones de entorno
function uc()
{
    echo "${*^^}"
}

function lc()
{
     echo "${1,,*}"
}

#FIN
