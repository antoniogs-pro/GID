#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: 
# Fichero para pre-procesar y depurar ficheros CSV de líneas y caracteres no válidos
# Genera fichero ficheroatratar.csv
#
# Última actualización: 2017/06/21
## Ultimo cambio realizado: eliminando mensajes por consola y pasarlos a fichero de LOG
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
FICHEROENTRADA="$1"
SALIDA=ficheroatratar.csv
#
##############################
# COMPROBACIONES DE CONTROL  #
##############################
echo Ejecutando $0 sobre $1 >> $LOGFILE
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
##############################
# PROCESO
##############################
echo  Convirtiendo fichero a UTF-8 sin BOM, Retornos de carro Unix, eliminando caracteres extraños. Genera ${SALIDA}
# 1º Convertir a UTF 8	sin BOM
$FUNPROC/2utf8.sh ${FICHEROENTRADA}
# 2º control de retorno de carros linux
$FUNPROC/2retornoscarro-lf.sh  ${FICHEROENTRADA}
# file ${FICHEROENTRADA} >> $LOGFILE
#4º número de líneas mayor de uno
      LINEAS=$(wc -l ${FICHEROENTRADA}| cut -d " " -f1 )
      if [ $LINEAS -lt 1 ] ; then
       echo " ATENCION: Agregando retorno de carro a fichero de una línea o menos" >> $LOGFILE
       echo -e "\n" >> ${FICHEROENTRADA}
      fi
#
# 5º ver si tiene caracteres extraños
cat -vet ${FICHEROENTRADA} | grep "^" >> $LOGFILE
if [ $? == 0 ] ; then
	echo tiene caracteres extraños >> $LOGFILE
# eliminando tabuladores
#	cat -e ${FICHEROENTRADA}  | tr "\t" " "| tr -s " " |  sed  -f $RUTA/depurar_caracteres.sed >  $SALIDA
# 5º depurar_caracteres_no_imprimibles
	echo depurarando caracteres no válidos,  Generando $SALIDA  >> $LOGFILE
	cat ${FICHEROENTRADA}  | tr -s " " |  sed  -f $FUNPROC/depurar_caracteres.sed >  $SALIDA
fi
# Singularidades
echo === Singularidades ===
echo  A- Registros con Campos vacios
cat -n $SALIDA | grep ",," | wc -l
cat -n $SALIDA | grep ",/," 
echo  A- Registros con Campos nombre vacios
cat -n $SALIDA | cut -d, -f 2,3,4 | grep ",," | wc -l
echo  B- Posibles errores "E+"
cat -n $SALIDA | grep "E+" | wc -l
echo  C- Caracteres extraños no controlados
cat -n $SALIDA | grep ["þ""©""¬""?""¿""œ""�"""""""] | wc -l
#
echo 'Expresión regular busca caracteres que NO (^) estén en el rango especificado '
grep  -n  [^0-9A-Za-z\,_' '-'@''/'] $SALIDA 
# siguiente línea en cuarentena agregada el 16-09-21, no funciona
# if [ $?=0 ]; then   echo ATENCION: encontrado errores ;echo pulse una tecla para seguir o Ctrl-c para abortar;read t; fi
echo =====================
if [ ! -f ${SALIDA}  -o !  -s ${SALIDA} ]
  then
cat << :error
	 ATENCIÓN: 
	 Ha habido errores al preparar el fichero a tratar. # . No existe o está vacio
:error
exit 253
fi







