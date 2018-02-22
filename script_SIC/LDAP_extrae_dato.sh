#!/bin/bash
# Script de busqueda de datos en LDAP
# Buscar por tndoc, UVUS y relación
# Autor Antonio González
# Fecha última modificación: 02/06/2014
#
EXTRAE=$SICSCRIPTS/extrae.pl
#EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
# Ej.
#$EXTRAE $RAMA -f "(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${DATO})"  -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life -a irismailmainaddress | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g
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
tipo_dato_buscar="$1"
DATO="$2"
CONDICION=""
#ARBOL=""
echo
#echo $0 $tipo_dato_buscar $DATO $CONDICION
case $tipo_dato_buscar in
"NDOC")
	CONDICION="(irisPersonalUniqueID=${DATO})"
;; # Fin opcion case NDOC
"TNDOC")
	CONDICION="(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${DATO})"
;; # Fin opcion case tndoc
"TNDOC-A6")
	CONDICION="(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:P:A6${DATO})"
;; # Fin opciones case A6
"TNDOC-FIUS")
	CONDICION="(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:P:FIUS${DATO})"
;; # Fin opciones case FIUS
"UVUS")
	CONDICION="(uid=${DATO})"
;; # Fin opcion case uvus
"RELACION")
	CONDICION="(UsEsRelacion=${DATO})"
;; # Fin opciones case relacion
"VINCULACION")
	CONDICION="(OU=${DATO})"
;; # Fin opciones case VINCULACION
"SEEALSO")
	CONDICION="(&(UsEsRelacion=MISCELANEA)(SEEALSO=uid=${DATO},o=us.es,dc=us,dc=es))"
;; # Fin opciones case VINCULACION

"" | "?")
echo .
echo USO:
echo "$0 tipo_busqueda  dato"
echo 'tipo de busqueda puede ser: TNDOC,NDOC, UVUS o RELACION  (Siempre en  MAYÚSCULAS)'
echo .
exit 255
;; # Fin opcion case default
esac  # fin case $1
#
#echo la condición es: $CONDICION
if [ ! "$CONDICION" == "" ]
 then
     echo buscando $CONDICION >&2
     echo schacpersonaluniqueid, irisPersonalUniqueID,Nombre, Apellido1, Apellido2, uid, inetuserstatus, Estado_UVUS, Estado_CORREO, Email_principal, Relaciones, Responsable, OU, Centro, Fecha_Validez, IMMA >&2
# Buscando en LDAP

 $EXTRAE -nodn $ARBOL -f "${CONDICION}"  -a schacpersonaluniqueid  -a irisPersonalUniqueID -a givenname -a sn1 -a sn2 -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a Mail -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life -a irismailmainaddress  | sed -e s/", o=us.es, dc=us, dc=es"//g  | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g 
#| grep   ^[DPX]: 

# reprocesar con awk
 else
 echo falta condicionante o está mal formulada: $CONDICION >&2
 exit 1
fi


