ruta=$SICSCRIPTS
EXTRAE=$SICSCRIPTS/extrae.pl
fuente=$1

>${fuente}+UVUS.csv
>$fuente.NO.tienen.UVUS


for ndoc in $(cat $fuente | sed -e 1d | cut -d, -f2)
 do
 


  UVUS=$($EXTRAE -f schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:"$ndoc" -a uid  -nodn)
  	 
          echo  $ndoc $UVUS

	  if [ "$UVUS" = "" ]
	  then
		echo $(grep $ndoc $fuente) | tee -a ${fuente}.NO.tienen.UVUS
	
	  else
		echo "$(grep $ndoc $fuente | cut -d, -f2,4,5,7,9),$UVUS" >> ${fuente}+UVUS.csv
	 
	  fi

    done

echo De $(wc -l $fuente) 
wc -l ${fuente}+UVUS.csv
wc -l $fuente.NO.tienen.UVUS
echo posibles errores no detectados
grep ",$"  ${fuente}+UVUS.csv

