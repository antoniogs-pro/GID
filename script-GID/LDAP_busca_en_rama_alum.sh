USR=$1
EXTRAE=$SICSCRIPTS/extrae.pl
perl $EXTRAE -b o=alum.us.es,dc=us,dc=es -f irisPersonalUniqueID=$USR -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a ou -a UsEsCentro -a iplanet-am-user-account-life -a irismailmainaddress | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g
