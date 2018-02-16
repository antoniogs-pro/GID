#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: Convertir ficheros de textos tabulados de ACAI a formato CSV separado por comas.
#
# Última actualización: 2017/05/19
## Ultimo cambio realizado: Uso de awk para controlar el encolumnado, agregar cabeceras y controles básicos
# Conversión a UTF8 sin BOM y eliminación de caracteres extraños.
# PTE: por alguna razón algunas líneas no poseen al final el nº que indica el sexo. Por suerte es un valor no usado en el proceso
# Como usarlo
# echo "Como usarlo: "$0" fichero TXT #Posibles nombres de ficheros acai_ficheroclaves_gra.txt acai_ficheroclaves_mas.txt umi_ent_crear_uvus.txt
########################################################################
#######################################
#Variables de entorno impresindibles  #
#######################################
#
#Variables de entorno iniciales
RUTA=${SICSCRIPTS=/home/sic/SIC/Gestion_Identidad}
export FUNPROC=$RUTA/bin

#Variables de entorno generales
if [ -f  $FUNPROC/entorno.sh ]; then . $FUNPROC/entorno.sh; fi 
. $FUNPROC/entorno.sh
## Agregado para perfilar mi entorno
if [ -f  $FUNPROC/ordenes.sh ]; then . $FUNPROC/ordenes.sh; fi 
. $FUNPROC/ordenes.sh 
# Incluir Funciones generales para perfilar mis SCRIPTS 
if [ -f  $FUNPROC/funciones.sh ]; then . $FUNPROC/funciones.sh; fi 
#Entorno específico
export LOGFILE=$LOGDIR/acaitocsv.log
#Posibles nombres de ficheros acai_ficheroclaves_gra.txt acai_ficheroclaves_mas.txt umi_ent_crear_uvus.txt
FICHEROENTRADA="$1"
> $LOGFILE
#
##############################
# COMPROBACIONES DE CONTROL  #
##############################
if [ "$FICHEROENTRADA" == "" ]
then
cat << :ayuda
	 ATENCIÓN: 
	 Debe especificar como argumento el nombre del FICHEROENTRADA TIPO TEXTO  a PROCESAR Y COVERTIR A (CSV)  UTF-8 sin BOM
         Posibles nombres de ficheros son: acai_ficheroclaves_gra.txt , umi_ent_crear_uvus.txt
:ayuda
 exit 1
fi
if [ ! -f "$FICHEROENTRADA" ]
  then
cat << :ayuda
	 ATENCIÓN: 
	 No existe el ficheo $FICHEROENTRADA	
:ayuda
  exit 1
fi
#
##############################
# PROCESO		     #
##############################
# información general y precauciones
#cat << :precaucion
#Para el caso de ficheros en formato XLS
#paso 1 uno (preferente)
#	 1º con hoja de cálculo abrir ${FICHEROENTRADA} en formato iso-8859-15-euro, eliminando cabecera
#	  guardar como ${FICHEROENTRADA}.csv en utf8 sin BOM y sin delimitador de campos
#
#	 Si ya está el ${FICHEROENTRADA} original en UTF8, saltar este paso y simplemente renombrar el fichero ${FICHEROENTRADA} con extensión .CSV
#
#	 pulse ctrl-c si no lo ha hecho o Enter para continuar 
#:precaucion
#read TECLA
##
##
# Normalizar NOMBRE DEL FICHERO RETIRAR espacios en blanco 
#
echo "=== normalizando nombre del fichero  ====  $FICHEROENTRADA" >> $LOGFILE
nombre=$(echo $FICHEROENTRADA | tr " "  "_")
if [ ! "$nombre" == "$FICHEROENTRADA" ]; then
 cp ${FICHEROENTRADA} $nombre
fi
FICHEROENTRADA=$nombre
# RETIRAR el PATH y extensión del NOMBRE DEL FICHERO
camino='.'
camino=`dirname ${FICHEROENTRADA}`
cd $camino
FICHEROENTRADA=`basename ${FICHEROENTRADA}`
extencion=${FICHEROENTRADA##*.}
nombre=${FICHEROENTRADA%.$extencion}
FICHEROSALIDA=${FICHEROENTRADA%.$extencion}
# -----
# solo para acai aún sin procesar y que incluyan cabecera
# 1º convertir a UTF-8 sin BOM
# eliminar las 7 primeras líneas de cabecera	
# $SED -i "1,7d" > ${FICHEROENTRADA}
#
$FUNPROC/2utf8.sh  ${FICHEROENTRADA}
# 2º control de retorno de carros linux
$FUNPROC/2retornoscarro-lf.sh  ${FICHEROENTRADA}
echo Depurando caracteres no válidos en  ${FICHEROENTRADA}
$SED -i  -f $FUNPROC/depurar_caracteres.sed ${FICHEROENTRADA} 
echo Convirtiendo $FICHEROENTRADA a CSV >> $LOGFILE
cat ${FICHEROENTRADA} |$AWK -v OFS=","  -F "|" -f $FUNPROC/acai2csv.awk > ${FICHEROSALIDA}.csv
#
# fin

