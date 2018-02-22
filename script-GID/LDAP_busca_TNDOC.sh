#!/bin/bash
EXTRAE=$SICSCRIPTS/extrae.pl

while read USUARIO
do
 $EXTRAE  -f "(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${USUARIO})" -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a givenname -a sn1 -a sn2  -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life | sed -e s/,dc=us,dc=es//g -e s/urn:mace:terena.org:schac:personalUniqueID:es://g  -e s/urn:mace:terena.org:schac:userStatus:us.es://g 
done
