#!/bin/bash 
AWK=/usr/bin/awk
# 
if [ "$1" == "" ]
then
fichero='acai_ficheroclaves.csv'
else
fichero=$1
fi
if [ "$SICSCRIPTS" == "" ]
then
ruta=~/SIC/script_SIC
else
ruta=$SICSCRIPTS
fi
>$fichero.tienen.UVUS
>$fichero.NO.tienen.UVUS
if [ "$2" == "" ]
then
colectivo=ERASMUS
else
colectivo=$2
fi


for ndoc in $(cat $1 | cut -d, -f2)
 do

  UVUS=$($ruta/extrae.pl -b o=us.es,dc=us,dc=es -nodn -f irisPersonalUniqueID=${ndoc} -a uid  )

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
