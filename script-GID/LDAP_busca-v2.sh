#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script:  Script de busqueda de datos en LDAP guiada por menús
#
# Última actualización: 2017/08/23
## Ultimo cambio realizado:
#
# Como usarlo
# echo "Como usarlo:  " . $0  "  OJO al punto para ejecutar en shell actual
########################################################################
#
# Todo lo anterior sustituido por un shell generico Agregados para perfilar mi entorno
# if [ -n "$BASH_ENV" ]; then . "$BASH_ENV" ;fi
#######################################
#Variables de entorno impresindibles  #
#######################################
#
#Variables de entorno iniciales
RUTA=${SICSCRIPTS=/home/sic/SIC/script_SIC}
export FUNPROC=$SICSCRIPTS/FUNCYPROC

#Variables de entorno generales
if [ -f  $FUNPROC/entorno.sh ]; then . $FUNPROC/entorno.sh; fi
## Agregado para perfilar mi entorno
if [ -f  $FUNPROC/ordenes.sh ]; then . $FUNPROC/ordenes.sh; fi  
# Incluir Funciones generales para perfilar mis SCRIPTS 
if [ -f  $FUNPROC/funciones.sh ]; then . $FUNPROC/funciones.sh; fi 
#Entorno específico
LOGFILE=$LOGDIR/plantilla.log
LOGFILE=$LOGDIR/bitacora.log
FICHEROENTRADA="$1"
#
### Funciones genéricas de entorno
function uc()
{
    echo "${*^^}"
}
#
function lc()
{
     echo "${1,,*}"
}
#
#
#
#
##############################
# COMPROBACIONES DE CONTROL  #
##############################
# verificando VPN
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
#
EXTRAE=$SICSCRIPTS/extrae.pl
#EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
DATO=$1
if [ "$DATO" == "" ] ; then
echo .
read -p "Introduce dato a buscar y pulse enter: " DATO
echo .
fi
#
# Tipo de búsqueda ?
#
echo
cat << MENU
	0 salir
	1 Buscar por nº documento
	2 Buscar por tipo y numero de documento
	3 Buscar por UVUS
	4 Buscar por Relación
        5 Buscar por vinculación
	6 Buscar por Apellidos y/o nombre
        7 Buscar por estado de UVUS (OK o NOVALIDO)
        8 Buscar por estado en LDAP (InetUserStatus)
        9 TODO

MENU
read -n1 menu 
#CONDICION-UID-todo="(uid="'*'")"
#CONDICION-UID-unico="${CONDICION}(uid=anglez)"
#CONDICION-UID-contiene="${CONDICION}(uid='*'anglez'*')"
CONDICION=""
CONDICION="(&"
CONDICION="${CONDICION}(inetuserstatus="Active")"
CONDICION="${CONDICION}(schacUserStatus="urn:mace:terena.org:schac:userstatus:us.es:uvus:OK")"
#CONDICION="${CONDICION}(MailUserStatus="Active")"
# do case
case $menu in
0)
exit 1
;;
1)
 CONDICION="(irisPersonalUniqueID=${DATO})"
;;
2)
 CONDICION="(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${DATO})"
;;
3)
 CONDICION="(uid=${DATO})"
;;
4)
 CONDICION="(UsEsRelacion=${DATO})"
;;
5)
 CONDICION="(OU=${DATO})"
;;
6)
echo $buscar | LDAP_busca_apellidos.sh 
exit 1
;;
7)
 CONDICION='(schacUserStatus="urn:mace:terena.org:schac:userstatus:us.es:uvus:OK")'
;;
*)
mensaje="Opción erronea, Abandonando script"; exit 1
;;
esac
CONDICION="${CONDICION})"
# RAMA ?
echo
cat << MENU

	0 salir
	1 RAMA PAS-PDI
	2 RAMA ALUMN
        3 RAMA AMBAS
        
MENU
read -n1  menu 
# do case
case $menu in
0)
exit 1
;;
1) # PAS-PDI
RAMA="-b o=us.es,dc=us,dc=es"
;;
2)  # ALUM
RAMA=" -b o=alum.us.es,dc=us,dc=es "
;;
3)
RAMA=""
;;
*)
mensaje="Opción erronea, Abandonando script"; exit 1
;;
esac
#
#
echo
ATRIBUTOS='-a schacpersonaluniqueid -a irisPersonalUniqueID -a uid -a schacuserstatus -a inetuserstatus -a UsEsRelacion -a ou -a seealso -a UsEsCentro -a iplanet-am-user-account-life'
SED='/bin/sed'
FILTRO=-e
FILTRO=${FILTRO}' s/",dc=us,dc=es"//g '-e' s/"urn:mace:terena.org:schac:personalUniqueID:es:"//g '-e' s/"urn:mace:terena.org:schac:userStatus:us.es:"//g '
echo
#echo  $EXTRAE -nodn $RAMA -f $CONDICION $ATRIBUTOS '|' $SED $FILTRO
EXTRAE=$MAQUETA
$EXTRAE -nodn $RAMA -f "$CONDICION" $ATRIBUTOS | $SED  $FILTRO | tee $DATO.ldap
# \
#       -e 's/", o=us.es, dc=us, dc=es"//g'  -e 's/",dc=us,dc=es"//g' \
#       -e 's/"urn:mace:terena.org:schac:personalUniqueID:es:"//g' \
#       -e 's/"urn:mace:terena.org:schac:userStatus:us.es:"//g'

echo


