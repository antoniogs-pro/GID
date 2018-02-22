#!/bin/bash 
# obtener UVUS asociado a un TDOC:NDOC
# para colectivos con prefijo en NDOC

# Para obtener UVUS asociado a documentos incluso si que tienen espacios en blanco
# ejecutar como
#    ./script.sh < fichero.txt 
#o   cat fichero.txt|./script.sh 
# o para pre-parsear
#   $(transformaciones sobre otro fichero) | ./script.sh 
# o para pruebas
#   head -2 pasaportes_con_espacios.txt|./script.sh
#   echo 'P:AA 082118'|./script.sh 

fichero=ficheroatratar.csv

if [ "$SICSCRIPTS" == "" ]
then
RUTA=~/SIC/script_SIC
else
RUTA=$SICSCRIPTS
fi
EXTRAE=$RUTA/extrae.pl
while read BDOC
do
 NDOC=$(echo $BDOC | tr ":" ","| cut -d , -f 2)
 UVUS=$(perl $EXTRAE -f irisPersonalUniqueID=$NDOC  -a uid  -nodn )


# A6
if [ "$1" == "A6" ] ; then
echo   $(grep -i "${NDOC:2}" $fichero |  awk -v OFS="," -F"," '{print  toupper($1),toupper($2),toupper($3),toupper($4),toupper($5),$6}'),$UVUS
fi
# CSIC
#A6
if [ "$1" == "CSIC" ] ; then
echo   $(grep -i "${NDOC:4}" $fichero |  awk -v OFS="," -F"," '{print  toupper($1),toupper($2),toupper($3),toupper($4),toupper($5),$6}'),$UVUS
fi
# IBIS
if [ "$1" == "IBIS" ] ; then
echo   $(grep -i "${NDOC:4}" $fichero |  awk -v OFS="," -F"," '{print  toupper($1),toupper($2),toupper($3),toupper($4),toupper($5),$6}'),$UVUS
fi
# FIUS no necesita devolver el UVUS ya viene en la solicitud
# IBIS no necesita devolver el UVUS ya viene en la solicitud
done


