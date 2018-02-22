#!/bin/bash 
# 
if [ "$1" == "" ]
then
fichero='acai_ficheroclaves.csv'
else
fichero=$1
fi
if [ "$SICSCRIPTS" == "" ]
then
ruta=~/SIC/Gestion_Identidad/bin
else
ruta=$SICSCRIPTS
fi
EXTRAE=$ruta/extrae.pl
>$fichero.tienen.UVUS
>$fichero.NO.tienen.UVUS
#
for ndoc in $(cat $1 | cut -d, -f2)
 do

  UVUS=$($EXTRAE -b o=us.es,dc=us,dc=es -nodn -f irisPersonalUniqueID=${ndoc} -a uid  )

	  if [ "$UVUS" = "" ]
	  then
		echo $(grep ${ndoc} $fichero) | tee -a $fichero.NO.tienen.UVUS
	
	  else
		echo  $(grep ${ndoc} $fichero),$UVUS >> $fichero.tienen.UVUS
                
	 
	  fi
done
echo De $(wc -l $1) 
wc -l $fichero.tienen.UVUS
wc -l $fichero.NO.tienen.UVUS
