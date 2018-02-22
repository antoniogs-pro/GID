#!/bin/bash
EXTRAE=$SICSCRIPTS/extrae.pl

while read USUARIO
do
if [ ! "$USUARIO" = "" ]
then
 ARBOL="$1"
 if [ "$ARBOL" = "pas" ]
  then
   ARBOL="-b o=us.es,dc=us,dc=es"
  else
   if [ "$ARBOL" = "alum" ]
    then
     ARBOL="-b o=alum.us.es,dc=us,dc=es"
    else 
     ARBOL=""
   fi
 fi

 $EXTRAE $ARBOL -f "(sn=${USUARIO} )" -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid -a cn  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g 
fi
done
