#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: Ver estado de la cuenta de correo y ofrecer la posibilidad de reconstruir los indices.
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado: Cabecera y entorno
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

#entorno específico correo
BUZON="buzonus.int"
ficheroDENY=/etc/dovecot/deny
ANTIVIRUS="antivirus1.int"
ficheroBADMAILFROM=/etc/postfix/bloqueados
CORREO=$1

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
if [ $# -eq 0 ]; then
 echo Debe especificar la direccion de correo a tratar
 exit 255
fi


#==================================================================================================================
# Cuenta de correo
CORREO=${1,,} # Convertido a minusculas
# Obtiene dominio de una direccion de e-mail (quita hasta el símbolo '@').
DOMINIOUVUS=${CORREO##*\@}
# Obtiene UVUS de una direccion de e-mail (quita hasta el símbolo '@').
UVUS=${CORREO%\@*}
#
if [ "$UVUS" == ""  -o "$DOMINIOUVUS" == "" ]
then
 echo Debe especificar UVUS y un dominio correctos  uvus\@us.es o uvus\@alum.us.es
 exit 255
fi
# Ver datos

echo E-Mail a procesar ${CORREO}
echo UVUS: ${UVUS} Dominio: ${DOMINIOUVUS}
#Seleccionar Buzon

if [ ${DOMINIOUVUS} == "us.es" ]; then
BUZON=buzonus.int
else
 if [ ${DOMINIOUVUS} == "alum.us.es" ]; then
  BUZON=buzalum.int
  else
  echo dominio ${DOMINIOUVUS} inválido
  exit 255
 fi
fi
#
echo Estado LDAP:
echo ==============
echo  $CORREO  - Estado LDAP  - Estado UVUS  - Estado de Correo  
$EXTRAE -f "(uid=${UVUS})"  -a inetuserstatus  -a schacuserstatus -a mailuserstatus  | sed -e s/,dc=us,dc=es//g| sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g 

echo Estado en buzonus
echo ===================
ssh -i $LLAVE root@$BUZON /usr/local/bin/estado_buzon.sh ${CORREO} | $GREP "STORAGE"
echo 'Desea reconstruir el buzon de' $CORREO '(S/N)?'
TECLA=t
while  [ $TECLA != S -a  $TECLA != N -a $TECLA != s -a  $TECLA != n ] ; do
read TECLA
done
if [ $TECLA = S -o $TECLA = s ] ; then
ssh -i $LLAVE root@$BUZON /usr/local/bin/reconstruye_buzon.sh ${CORREO} 
fi
# $SICSCRIPTS/estado_d_bloqueo.sh $CORREO
# Fin del script

