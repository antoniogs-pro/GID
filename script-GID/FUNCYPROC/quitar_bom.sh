#!/bin/bash
####################################################################################
# Autor: Antonio González
# Proposito del script: 
# Eliminar la marca BOm en los ficheros UTF8
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado:
#  agregado argumento y comprovaciones de control
# Como usarlo
# echo "Como usarlo:  " . $0  "  OJO al punto para ejecutar en shell actual
####################################################################################
##############################
# COMPROBACIONES DE CONTROL  #
##############################
if [ "$1" == "" ]
then
cat << :ayuda
	 ATENCIÓN: 
	 Debe especificar como argumento el nombre del FICHEROENTRADA TIPO TEXTO (CSV)  a PROCESAR Y COVERTIR A UTF-8.
:ayuda
 exit 1
fi
if [ ! -f $1 ]
  then
     cat << :ayuda
	 ATENCIÓN: 
	 No existe el ficheo ${FICHEROENTRADA}	
:ayuda
  exit 1
fi
sed -i 's/^\xEF\xBB\xBF//' $1
