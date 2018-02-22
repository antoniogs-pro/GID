#!/bin/bash
EXTRAE=$SICSCRIPTS/extrae.pl
while read USUARIO
do
if [ ! "$USUARIO" = "" ]
then
$EXTRAE  -f "(uid=$USUARIO)" -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid -a schacuserstatus -a inetuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g
fi
done


