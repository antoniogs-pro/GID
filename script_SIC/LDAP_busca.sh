#! /bin/bash
#!/bin/bash
# Script de busqueda de datos en LDAP
# Buscar por tndoc, UVUS y relación
# Autor Antonio González
# Fecha última modificación: 02/06/2014
# Fecha última modificación: 28/11/2016
#
#ejemplo
#perl $EXTRAE  -f irisPersonalUniqueID=$NDOC -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a givenname -a sn -a uid -a schacuserstatus -a inetuserstatus -a mailuserstatus  -a irismailmainaddress -a UsEsRelacion -a ou -a seealso -a UsEsCentro  -a iplanet-am-user-account-life | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g
#UVUS=$(perl $EXTRAE -f irisPersonalUniqueID=$NDOC  -a uid  -nodn )
#
#
# Verificaciones
IFVPN=$(ifconfig | grep "tun" | cut -d " " -f 1)
if [ "$IFVPN" = "" ]
then
 echo .·: ----------------------------------:·.
 echo .   Recuerda ARMAR la VPN,               .
 echo ·.: ----------------------------------:.·
if [ "$DISPLAY" == ":0" ] ; then
zenity --error --timeout=5 --title="Error - ARMAR LA vpn" --text=" Recuerda ARMAR la VPN,"
notify-send --urgency=low "Interfaces VPN  $IFVPN  DesActivas"
exit 255
fi
else 
# echo Interfaces VPN  $IFVPN  Activas
echo
fi
#
EXTRAE=$SICSCRIPTS/extrae.pl
#EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
buscar=$1
#
cat << MENU
	0 salir
	1 Buscar por Nº documento
	2 Buscat por Tipo y numero de documento
	3 Buscar por UVUS
	4 Buscar por Relación
        5 Buscar Vinculación
	6 Buscar por Apellidos
	7 Buscar por Responsable

MENU
read -n1 menu 
if [ "$buscar" == "" ] ; then
echo .
read -p "Introduce dato a buscar y pulse enter: " buscar
echo .
fi
# do case
case $menu in
1)
LDAP_extrae_dato.sh NDOC $buscar
;;
2)
LDAP_extrae_dato.sh TNDOC $buscar
;;
3)
LDAP_extrae_dato.sh UVUS $buscar
;;
4)
LDAP_extrae_dato.sh RELACION $buscar
;;
5)
LDAP_extrae_dato.sh VINCULACION $buscar
;;
6)
#LDAP_extrae_dato.sh APELLIDOS $buscar
echo $buscar | LDAP_busca_apellidos.sh 
exit 1
;;
7)
LDAP_extrae_dato.sh SEEALSO $buscar
;;
*)
mensaje="Opción erronea, Abandonando script"; exit 1
;;
esac
