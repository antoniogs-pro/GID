#!/bin/bash
#
if [ "$SICSCRIPTS" == "" ]
then
RUTA=~/SIC/script_SIC
else
RUTA=$SICSCRIPTS
fi
#
if [ "$1" == "" ]
then
cat >&2 << :ayuda
	 ATENCIÓN: 
	 Debe especificar el nombre del FICHERO de ENTRADA tipo texto (CSV)  a procesar.
	 sintaxis:
	 $0 nombre_FICHERO
:ayuda
exit 255
fi
EXTRAE=$RUTA/extrae.pl
FICHERO=$1
DIRDATOS=$HOME/SIC/Gestion_identidad/BA/
TMP=$PWD
cat $FICHERO | cut -d, -f1,2 | tr "," ":" | LDAP_busca_TNDOC.sh > $TMP/datos.ldap
for i in $(cat $TMP/$FICHERO | cut -d, -f2) ; do  grep -ioHsr "$i" $DIRDATOS/*; done > ficheros_con_datos_encontrados
#
echo Descripción del Proceso 
# BA borrar antiguo desde NUEVODOCUMENTO
echo 1º Lanzar en IDM la BA eliminar.ba para eliminar el documento
 cat $TMP/datos.ldap |cut -d"|" -f1 |tee  $TMP/eliminar.ba
echo pulse una tecla cuando haya terminado
read t
#
> UVUS.txt
# Generando sentencia SQL para quitar de UVUS eliminados los UVUS que se van recuperar.
echo Generando sentencia SQL para quitar de UVUS eliminados los UVUS que se van recuperar.
echo 'SELECT * FROM uids_eliminados WHERE uvus in ('  > $TMP/sql.txt
for UVUS in $(cat $TMP/datos.ldap |cut -d"|" -f6); do
echo ${UVUS}, >> $TMP/sql.txt
echo ${UVUS} >> UVUS.txt
done
echo ');' >> $TMP/sql.txt
echo 2º Paso OPCIONAL , consultar UVUS eliminado con la siguiente sentencia SQL
cat $TMP/sql.txt
echo
#
echo 3º Borrar de UVUS eliminados para recuperar el UVUS,
> $TMP/limpia-eliminados.sh
for UVUS in $(cat $TMP/datos.ldap |cut -d"|" -f6); do
echo "TI_borra_eliminado.sh $UVUS" | tee -a $TMP/limpia-eliminados.sh
done
echo
# BA alta
echo Generando fichero para alta cambiando VIEJODOCUMENTO por NUEVODOCUMENTO
cat $FICHERO | cut -d, -f3,4,5,6,7,8 > $TMP/alta.csv

echo 4º Lanzar en IDM la BA para dar de alta a usuario del colectivo $colectivo
BA.sh alta.csv

