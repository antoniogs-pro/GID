#!/bin/bash
# Autor: Antonio González
# Última actualización: 2017/03/03
#
# Notas:
#
# Cargar el entorno
. $SICSCRIPTS/entorno.sh
# comprobaciones
if [ "$1" == "" ]
then
cat >&2 << :ayuda
	 ATENCIÓN: 
	 Debe especificar el nombre del FICHERO de ENTRADA  a procesar.
	 sintaxis:
	 $0 nombre_FICHERO
:ayuda
exit 255
unset FICHEROENTRADA
FICHEROENTRADA=$1
fi
if [ ! -f "${FICHEROENTRADA}" ]
then
cat >&2 << :ayuda
	 ATENCIÓN: 
	 No existe el ficheo $FICHEROENTRADA	
	 sintaxis:
	 $0 nombre_FICHERO
:ayuda
 exit 254
fi


# RETIRAR el PATH, espacios en blanco y extensión del NOMBRE DEL FICHERO
#
# === normalizando fichero  ====  $FICHEROENTRADA >> $LOG
nombre=$(echo $FICHEROENTRADA | tr " "  "_")
cp "$FICHEROENTRADA" $nombre
FICHEROENTRADA=$nombre
unset nombre
camino='.'
camino=`dirname ${FICHEROENTRADA}`
cd $camino
FICHEROENTRADA=`basename ${FICHEROENTRADA}`
extencion=${FICHEROENTRADA##*.}
FICHEROSALIDA=${FICHEROENTRADA%.$extencion}
# reparto en tandas de 500
split -l 500 -d --additional-suffix=.txt $FICHEROENTRADA  ${FICHEROSALIDA}-

