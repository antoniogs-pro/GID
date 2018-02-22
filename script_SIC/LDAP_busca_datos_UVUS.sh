#!/bin/bash
EXTRAE=$SICSCRIPTS/extrae.pl
if [ "$1" == "" ]; then
cat << :mensaje

echo Falta dato requerido
sintaxis: $0 uvus [rama]
donde rama es opcional para todas o podrá ser pas o alum para cada tipo de rama

:mensaje
fi
USUARIO="$1"
shift
if [ ! "$USUARIO" == "" ]
then
 ARBOL="$1"
 if [ "$ARBOL" == "pas" ]
  then
   ARBOL="-b o=us.es,dc=us,dc=es"
  else
   if [ "$ARBOL" == "alum" ]
    then
     ARBOL="-b o=alum.us.es,dc=us,dc=es"
    else 
     ARBOL=""
   fi
 fi
 $EXTRAE $ARBOL -f "(uid=${USUARIO})" -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a sn1 -a sn2 -a givenname -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g
fi

