#!/bin/bash
. ~/entorno.sh
EXTRAE=$SICSCRIPTS/extrae.pl
  echo Usuario - Estado LDAP - Estado de Correo - Estado UVUS
for i in  $* ; do
   $EXTRAE -f "(uid=$i)" -a inetuserstatus -a mailuserstatus -a schacuserstatus | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g
done
