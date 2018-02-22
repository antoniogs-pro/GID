#!/bin/bash 
if [ "$SICSCRIPTS" == "" ]
then
RUTA=~/SIC/script_SIC
else
RUTA=$SICSCRIPTS
fi
EXTRAE=$RUTA/extrae.pl
fuente=$1
#rama="pas"
if [ ! "$1"  = "" ]
then
fuente=$1
bucle="for ndoc in $(cat $fuente |cut -d, -f1,2 | tr "," ":" ) "
else
bucle="while read ndoc"
fi
t=0
s=0
n=0
FicheroDatos=$fuente.datos
FicheroNoDatos=$fuente.No_UVUS
>$FicheroDatos
>$FicheroNoDatos

#$bucle ;
#while read ndoc
for ndoc in $(cat $fuente |cut -d, -f1,2 | tr "," ":" )
do
 echo $ndoc
 UVUS=$($RUTA/extrae.pl -f schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:"${ndoc}" -a uid  -nodn)
  
	if [ "$UVUS" = "" ]
	then
               	echo $ndoc | tee -a $FicheroNoDatos
		n=$(expr $n + 1)

	else
        echo $UVUS
# "${ndoc}"  "$rama"
        echo $ndoc | $RUTA/busca_TNDOC_ldap.sh   | tee -a  $FicheroDatos
                s=$(expr $s + 1)
	fi

done
echo Entradas procesadas $(wc -l $fuente) 
echo $n No tiene UVUS y $s hay datos 

wc -l $FicheroDatos
wc -l $FicheroNoDatos

