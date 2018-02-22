#!/bin/bash
# Script de listado completo de LDAP incluye alias de correo
# 
# Autor Antonio González
# Fecha última modificación: 21/03/2017
#
EXTRAE=$SICSCRIPTS/extrae.pl
#EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
$EXTRAE -f "(uid=*)" -nodn -a schacpersonaluniqueid  -a irisPersonalUniqueID -a CN -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a Mail -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life -a irismailmainaddress -a irismailalternateaddress -a mailequivalentaddress | sed -e s/", o=us.es, dc=us, dc=es"//g  | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g | tee listado-completo.ldap

