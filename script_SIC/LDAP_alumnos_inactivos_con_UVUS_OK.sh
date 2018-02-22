EXTRAE=$SICSCRIPTS/extrae.pl
EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
echo procesando espere
perl $EXTRAE -b o=alum.us.es,dc=us,dc=es  -f "(&(UsEsRelacion="ALUMNO")(inetuserstatus="InActive")(schacUserStatus="urn:mace:terena.org:schac:userstatus:us.es:uvus:OK"))"  -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life -a irismailmainaddress | sed -e s/,dc=us,dc=es//g  -e s/urn:mace:terena.org:schac:personalUniqueID:es://g  -e s/urn:mace:terena.org:schac:userStatus:us.es://g  |tee alumnos_inactivos_uvus_ok.ldap
echo terminado generado fichero $PWD/alumnos_inactivos_uvus_ok.ldap
# urn:mace:terena.org:schac:userstatus:us.es:uvus:OK
# Valores posibles terminando en: OK, NOVALIDO, INACTIVO Y PENDIENTE
#"(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${USUARIO})"
