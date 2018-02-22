USR=$1
EXTRAE=$SICSCRIPTS/extrae.pl
$EXTRAE -b o=us.es,dc=us,dc=es  -f irisPersonalUniqueID=$USR -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid -a schacuserstatus -a inetuserstatus -a UsEsRelacion -a ou -a seealso -a UsEsCentro -a iplanet-am-user-account-life | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g

