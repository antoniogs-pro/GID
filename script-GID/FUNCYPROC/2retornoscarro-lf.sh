#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: 
# Fichero para pre-procesar y convertir ficheros de texto y CSV los retornos de carro a retornos de carro linux (lf)
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado: creado
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
RUTA=${SICSCRIPTS=/home/sic/SIC/script_SIC}
export FUNPROC=$SICSCRIPTS/FUNCYPROC

#Variables de entorno generales
if [ -f  $FUNPROC/entorno.sh ]; then . $FUNPROC/entorno.sh; fi
## Agregado para perfilar mi entorno
if [ -f  $FUNPROC/ordenes.sh ]; then . $FUNPROC/ordenes.sh; fi  
# Incluir Funciones generales para perfilar mis SCRIPTS 
if [ -f  $FUNPROC/funciones.sh ]; then . $FUNPROC/funciones.sh; fi 
#Entorno específico
LOGFILE=$LOGDIR/2retornoscarro-lf.log
FICHEROENTRADA="$1"
#
##############################
# COMPROBACIONES DE CONTROL  #
##############################
echo Ejecutando $0 sobre $1 >> $LOGFILE
if [ "$1" == "" ]
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
################
# ver si tiene retornos de carro válidos

	file ${FICHEROENTRADA} | grep " CR" >> $LOGFILE
	if [ $? == 0 ]; then
	 echo Eliminando retornos de carro MAC - CR >> $LOGFILE
	 mac2unix ${FICHEROENTRADA} 2>> $LOGFILE
	fi
# tiene retornos de carro CR sueltos
	cat -vet ${FICHEROENTRADA} | grep "M\$$"  >> $LOGFILE
	if [ $? == 0 ]; then
	 echo tiene retornos de carro CR >> $LOGFILE
	 mac2unix ${FICHEROENTRADA} 2>> $LOGFILE
	fi
# tiene retornos de carro CRLF
	file ${FICHEROENTRADA} | grep "CRLF" >> $LOGFILE
	if [ $? == 0 ]; then
	 echo Eliminando retornos de carro MS - CRLF >> $LOGFILE
	 dos2unix ${FICHEROENTRADA} 2>> $LOGFILE
	fi
# NO tine saltos de linea unix correctos LF
	cat -vet ${FICHEROENTRADA} | grep -v "\$$"  >> $LOGFILE
	if [ $? == 0 ]; then
	 echo No tiene saltos de linea unix correctos LF >> $LOGFILE
	 dos2unix ${FICHEROENTRADA} >> $LOGFILE
	fi

# tiene saltos de linea unix correctos LF
	cat -vet ${FICHEROENTRADA} | grep "\$$" >> $LOGFILE
	if [ $? == 0 ]; then
	 echo tine saltos de linea unix correctos LF >> $LOGFILE
        else
         echo abortado por error de tipo de fichero
         file ${FICHEROENTRADA}
         exit 255 
	fi
#
# fin
