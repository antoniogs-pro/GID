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


if [ "$SICSCRIPTS" == "" ]
then
RUTA=~/SIC/script_SIC
else
RUTA=$SICSCRIPTS
fi
EXTRAE=$RUTA/extrae.pl
#ARBOL="-b o=us.es,dc=us,dc=es"
while read TNDOC
do
 NDOC=$(echo $TNDOC | tr ":" ","| cut -d , -f 2)
 UVUS=$(perl $EXTRAE $ARBOL -f irisPersonalUniqueID=${NDOC}  -a uid  -nodn )
 echo $TNDOC,$UVUS
 echo   $(grep -i "${NDOC}" ficheroatratar.csv |  awk -v OFS="," -F"," '{print  toupper($1),toupper($2),toupper($3),toupper($4),toupper($5)}'),$UVUS

# para colectivos con prefijo en NDOC
#echo   $(grep -i "${NDOC:2}" ficheroatratar.csv |  awk -v OFS="," -F"," '{print  toupper($1),toupper($2),toupper($3),toupper($4),toupper($5)}'),$UVUS

done


