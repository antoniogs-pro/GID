#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: Genera Ba para agregar colectivo a usuarios. Lo correcto se debe añadir la relación + vinculo
#
# Última actualización: 2017/07/04
## Ultimo cambio realizado: Agregar cabecera de plantilla
#
# Como usarlo
# echo "Como usarlo:  "  $0  fichero.csv  " 
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
export FUNPROC=$SICSCRIPTS/FUNCYPROC

#Variables de entorno generales
if [ -f  $FUNPROC/entorno.sh ]; then . $FUNPROC/entorno.sh; fi
## Agregado para perfilar mi entorno
if [ -f  $FUNPROC/ordenes.sh ]; then . $FUNPROC/ordenes.sh; fi  
# Incluir Funciones generales para perfilar mis SCRIPTS 
if [ -f  $FUNPROC/funciones.sh ]; then . $FUNPROC/funciones.sh; fi 
#Entorno específico
FICHEROATRATAR=ficheroatratar.csv
FICHEROENTRADA=agregar-colectivo.csv
FICHEROENTRADA="$1"
#
RELACION=PROFESORSECUNDARIA
COLECTIVO="MAES"
FVENCIMIENTO=2018/09/30
FICHEROBA=agregar-colectivo-${COLECTIVO}.ba
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
# pendiente como usar $nombre
camino='.'
camino=`dirname ${FICHEROENTRADA}`
cd $camino
FICHEROENTRADA=`basename ${FICHEROENTRADA}`
extencion=${FICHEROENTRADA##*.}
FICHEROSALIDA=${FICHEROENTRADA%.$extencion}
#
LOGFILE=$LOGDIR/${FICHEROSALIDA}.log
RELACION=PROFESORSECUNDARIA
COLECTIVO="MAES"
FVENCIMIENTO=2018/09/30
FICHEROBA=agregar-colectivo-${COLECTIVO}.ba

##############################
# PROCESO		     #
##############################

echo "Command,User,waveset.roles,accounts[DirectorioCorporativo\|PAS PDI].fechaValidez,accounts[Lighthouse].fechaValidez,accounts[DirectorioCorporativo\|PAS PDI].vinculacion" > $FICHEROBA
awk -v fvencimiento="$FVENCIMIENTO" -v colectivo="$COLECTIVO" -v RELACION="$RELACION" -v OFS="," -F"," '{print  "Update",toupper($1)":"$2,"|Merge|"RELACION,fvencimiento,fvencimiento,colectivo;}' ${FICHEROENTRADA} | tee -a  $FICHEROBA
#FIN




