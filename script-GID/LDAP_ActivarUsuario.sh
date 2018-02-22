usuario=$1  # UVUS del USUARIO
echo > Activar_usuario.ldif
echo "dn: uid=$usuario,o=alum.us.es,dc=us,dc=es" >> Activar_usuario.ldif
echo "changetype: modify">>Activar_usuario.ldif
echo "replace: inetUserStatus">>Activar_usuario.ldif
echo "inetUserStatus: Active">>Activar_usuario.ldif
password=%,yntqy.
ldapmodify -H ldap://ldap1.int -D "cn=directory manager" -w "$passwd" -x -f Activar_usuario.ldif 
#comprobar estado
perl $SICSCRIPTS/extrae.pl -b o=alum.us.es,dc=us,dc=es  -f "(&(UsEsRelacion="ALUMNO")(uid="$usuario"))"  -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life -a irismailmainaddress | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g 
