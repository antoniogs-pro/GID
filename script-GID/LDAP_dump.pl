#!/usr/bin/perl
# Script perl para obtener dump de LDAP
#ejemplo uid=lacruz,o=alum.us.es,dc=us,dc=es|urn:mace:terena.org:schac:personalUniqueID:es:D:00812881, nombre+apellidos
# $salida SE OBTIENE CON ESTE COMANDO: perl extrae.pl -nodn -a schacPersonalUniqueID -a cn > $entrada
$salida ="dump_usuarios_ldap";
$ruta= `env | grep SICSCRIPTS| cut -d"=" -f2`;
chop($ruta);
$argumentos=" -nodn -a schacPersonalUniqueID -a cn -a sn1 -a sn2 -a givenname -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life";
$extrae="$ruta/extrae.pl ";
$comando="$extrae $argumentos";
print "Ejecutando $comando \n espere un monento \n";
# 2016-05-3 he agregado | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g  para un resultado más limpio, 
system("$comando | grep   ^[DPX]: | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g |  sed -e s/,o=us.es//g \ | tee  $salida" ) ;
# fin


