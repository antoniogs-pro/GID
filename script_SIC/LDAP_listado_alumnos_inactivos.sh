# (inetuserstatus="Active")
# (inetuserstatus="InActive")
perl $SICSCRIPTS/extrae.pl -b o=alum.us.es,dc=us,dc=es  -f "(&(UsEsRelacion="ALUMNO")(inetuserstatus="InActive"))"  -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life -a irismailmainaddress | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g | grep "|ALUMNO|" | cut -d"," -f1 | cut -d"=" -f 2|tee alumnos-inactivos.ldap 

