#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: 
# Fichero para pre-procesar y convertir ficheros de texto y CSV,  a UTF-8
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado: Añandir cabecera, eliminando mensajes por consola y pasarlos a fichero de LOG
#
# Como usarlo
# echo "Como usarlo:  "$0  fichero_entrada"
########################################################################
#
#######################################
#Variables de entorno impresindibles  #
#######################################
#
#Variables de entorno iniciales
export RUTA=${HOME}/SIC/Gestion_Identidad/bin

#Variables de entorno generales

if [ -f  $RUTA/entorno.sh ]; then . $RUTA/entorno.sh; fi

#Entorno específico
FICHEROENTRADA="$1"
#
##############################
# COMPROBACIONES DE CONTROL  #
##############################
echo Ejecutando $0 sobre $1 >> $LOGFILE
FICHEROENTRADA=$1
if [ "$1" == "" ]
then
cat << :ayuda
	 ATENCIÓN: 
	 Debe especificar como argumento el nombre del FICHEROENTRADA TIPO TEXTO (CSV)  a PROCESAR Y COVERTIR A UTF-8.
:ayuda
 exit 1
fi
if [ ! -f $FICHEROENTRADA ]
  then
     cat << :ayuda
	 ATENCIÓN: 
	 No existe el ficheo $FICHEROENTRADA	
:ayuda
  exit 1
fi
################
#   Proceso    #
################
file ${FICHEROENTRADA} | grep "UTF-8"  >> $LOGFILE
if [ $? -gt 0 ] ; then
   vi ${FICHEROENTRADA} '+set fenc=utf-8' '+x'
fi
# 2º Ver si tiene BOM ?
file $FICHEROENTRADA | grep "BOM"   >> $LOGFILE
if [ $? == 0 ]; then
  echo tiene BOM detectado por file, quitando  BOM  >> $LOGFILE
  sed -i 's/^\xEF\xBB\xBF//' ${FICHEROENTRADA}
fi
# FIN
