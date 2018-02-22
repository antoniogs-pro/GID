#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: 
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado:
#
# Como usarlo
# echo "Como usarlo:  " . $0  "  OJO al punto para ejecutar en shell actual
########################################################################
#
# Todo lo anterior sustituido por un shell generico Agregados para perfilar mi entorno
# if [ -n "$BASH_ENV" ]; then . "$BASH_ENV" ;fi
#######################################
#Variables de entorno impresindibles  #
#######################################
#
#Variables de entorno iniciales
RUTA=${SICSCRIPTS=/home/sic/SIC/script_SIC}
export FUNPROC=$RUTA/FUNCYPROC

#Variables de entorno generales
if [ -f  $FUNPROC/entorno.sh ]; then . $FUNPROC/entorno.sh; fi
## Agregado para perfilar mi entorno
if [ -f  $FUNPROC/ordenes.sh ]; then . $FUNPROC/ordenes.sh; fi  
# Incluir Funciones generales para perfilar mis SCRIPTS 
if [ -f  $FUNPROC/funciones.sh ]; then . $FUNPROC/funciones.sh; fi 
#Entorno específico
LOGFILE=$LOGDIR/bitacora.log
FICHEROENTRADA="$1"
#
### Funciones genéricas de entorno
function uc()
{
    echo "${*^^}"
}
#
function lc()
{
     echo "${1,,*}"
}
#
#
#
#
##############################
# COMPROBACIONES DE CONTROL  #
##############################
# verificando VPN
IFVPN=$(ifconfig | grep "tun" | cut -d " " -f 1)
if [ "$IFVPN" = "" ]
then
 echo .·: ----------------------------------:·.
 echo .   Recuerda ARMAR la VPN,               .
 echo ·.: ----------------------------------:.·
if [ "$DISPLAY" == ":0" ] ; then
zenity --error --timeout=5 --title="Error - ARMAR LA vpn" --text=" Recuerda ARMAR la VPN,"
notify-send --urgency=low "Interfaces VPN  $IFVPN  DesActivas"
exit 255
fi
else 
# echo Interfaces VPN  $IFVPN  Activas
echo
fi
#
##############################
# COMPROBACIONES DE CONTROL # Verificaciones previas sobre ficheros #
##############################
if [ "$FICHEROENTRADA" == "" ]
then
cat << :ayuda
	 ATENCIÓN: 
	 Debe especificar como argumento el nombre del FICHEROENTRADA TIPO TEXTO (CSV)  a PROCESAR Y COVERTIR A UTF-8.
:ayuda
 exit 1
fi
if [ ! -f ${FICHEROENTRADA} ]
  then
     cat << :ayuda
	 ATENCIÓN: 
	 No existe el ficheo ${FICHEROENTRADA}	
:ayuda
  exit 1
fi
###################################
# COMPROBACIONES para el proceso #
###################################
# PARA PRO DEJAR EN BLANCO LA VARIABLE PRE
PRE=
TMPDIR=~/tmp
if [ "$1" == "-p"  ]; then
   PRE=2
   CPRE="   ATENCION: BUSCANDO EN MAQUETA "
   EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
   PREoPRO='-P'
   shift
else
   PRE=''
   CPRE="  BUSCANDO EN PRODUCCIÓN " 
   EXTRAE=$SICSCRIPTS/extrae.pl
fi
if [ "$2" == "-p"  ]; then
   CPRE="   ATENCION: BUSCANDO EN MAQUETA " 
   PRE=2
   EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
  PREoPRO='-P'
fi
#
echo $CPRE  
#
# RETIRAR el PATH, espacios en blanco y extensión del NOMBRE DEL FICHERO
#

echo -=== normalizando fichero  ====-  $FICHEROENTRADA >> $LOGFILE
nombre=$(echo $FICHEROENTRADA | tr " "  "_")
[  $FICHEROENTRADA = $nombre ] ||  cp "$FICHEROENTRADA" $nombre
FICHEROENTRADA=$nombre
camino='.'
camino=`dirname ${FICHEROENTRADA}`
cd $camino
FICHEROENTRADA=`basename ${FICHEROENTRADA}`
extencion=${FICHEROENTRADA##*.}
FICHEROSALIDA=${FICHEROENTRADA%.$extencion}
FICHEROATRATAR=ficheroatratar.csv


# pendiente como usar $nombre
##############################
# PROCESO		     #
##############################





#FIN
