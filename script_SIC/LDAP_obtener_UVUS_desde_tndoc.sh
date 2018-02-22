#!/bin/bash 
# obtener UVUS asociado a un TDOC:NDOC
# Para obtener UVUS asociado a documentos incluso si que tienen espacios en blanco
# ejecutar como
#    ./script.sh < fichero.txt 
#o   cat fichero.txt|./script.sh 
# o para pre-parsear
#   $(transformaciones sobre otro fichero) | ./script.sh 
# o para pruebas
#   head -2 pasaportes_con_espacios.txt|./script.sh
#   echo 'P:AA 082118'|./script.sh 
if [ "$1" == "" ]
then
fichero=ficheroatratar.csv
else
fichero=$1
fi
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
# perl $EXTRAE $ARBOL -s "," -nodn  -f "schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${BDOC}" -a schacpersonaluniqueid -a givenname -a sn1 -a sn2 -a uid -a UsEsRelacion  | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g 
# 

UVUS=$(perl $EXTRAE $ARBOL -f "schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${BDOC}" -nodn -a uid  )
echo   $(grep -i "$NDOC" $fichero| uniq |  awk -v OFS="," -F"," '{print  toupper($1),toupper($2),toupper($3),toupper($4),toupper($5),$6,$7}'),"${UVUS}"

done


