#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: Para ver el estado  de las cuentas de correos y si estna bloqueada o no  en buzones por haber estado comprometidas y emitiendo spamm
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
export FUNPROC=$RUTA/FUNCYPROC

#Variables de entorno generales
if [ -f  $FUNPROC/entorno.sh ]; then . $FUNPROC/entorno.sh; fi
## Agregado para perfilar mi entorno
if [ -f  $FUNPROC/ordenes.sh ]; then . $FUNPROC/ordenes.sh; fi  
# Incluir Funciones generales para perfilar mis SCRIPTS 
if [ -f  $FUNPROC/funciones.sh ]; then . $FUNPROC/funciones.sh; fi 
#Entorno específico
LOGFILE=$LOGDIR/bitacora.log
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
#============================================================================================================================
#entorno específico correo
BUZON="buzonus.int"
ficheroDENY=/etc/dovecot/deny
ANTIVIRUS="antivirus1.int"
ficheroBADMAILFROM=/etc/postfix/bloqueados
#
CORREO=$1
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
# $SICSCRIPTS/estado_buzon.sh $CORREO
echo Estado LDAP:
echo ==============
echo  $CORREO  - Estado LDAP  - Estado UVUS  - Estado de Correo  
$EXTRAE -f "(uid=${UVUS})"  -a inetuserstatus  -a schacuserstatus -a mailuserstatus  | sed -e s/,dc=us,dc=es//g| sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g 
echo Estado en buzonus
echo ===================
ssh -i $LLAVE root@$BUZON /usr/local/bin/estado_buzon.sh ${CORREO} | $GREP "STORAGE"

echo Estado de bloqueos en BUZONES
echo ============================
ssh -i $LLAVE root@$BUZON $GREP  "${CORREO}" $ficheroDENY
 if  [ $? = 1 ] ;  then
   echo  NO BLOQUEADO en Buzones
 fi
#echo Estado en ANTIVIRUS
#ssh -i $LLAVE root@$ANTIVIRUS $GREP "${CORREO}" $ficheroBADMAILFROM
# if  [ $? = 1 ] ;  then
#   echo  No bloqueado en Antivirus
# fi
cat << :precaucion

	 Los que tienen cuentas bloqueadas deben cambiar la contraseña antes del desbloqueo.
	Se les debe indicar que limpien de virus el equipo y comprueben su configuración en correo 
	por si les han falseado el reply-to y la firma.   
 
:precaucion


# Fin del script
