#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: Para desbloquear cuentas de correos bloquedas en buzones por haber estado comprometidas y emitiendo spamm
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
#============================================================================================================================
#
BUZON="buzonus.int"
ficheroDENY=/etc/dovecot/deny
ANTIVIRUS="antivirus1.int"
ficheroBADMAILFROM=/etc/postfix/bloqueados
#
#
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
# para pruebas
cd ~/tmp
#scp root@$ANTIVIRUS:$ficheroBADMAILFROM ~/tmp/bloqueados
#scp root@$BUZON:$ficheroDENY ~/tmp/deny
#ficheroDENY=~/tmp/deny
#ficheroBADMAILFROM=~/tmp/bloqueados
# fin para pruebas, comentarlo al finalizarlas


ssh root@$BUZON $GREP  "^${UVUS}$" $ficheroDENY
#$GREP  "^${UVUS}$" $ficheroDENY
 if  [ $? = 0 ] 
 then
  echo Desbloqueando a $CORREO en $BUZON de la US
#$SED -i "/^${UVUS}$/d" $ficheroDENY
#$SED -i "/^${UVUS}@${DOMINIOUVUS}/d" $ficheroDENY
  ssh root@$BUZON $SED -i "/^${UVUS}$/d" $ficheroDENY
  ssh root@$BUZON $SED -i "/^${UVUS}@${DOMINIOUVUS}/d" $ficheroDENY
 else
  echo $CORREO No está bloqueado en $BUZON de la US
 fi

ssh root@antivirus1.int $GREP "${UVUS}@${DOMINIOUVUS}" $ficheroBADMAILFROM
#$GREP "${UVUS}@${DOMINIOUVUS}" $ficheroBADMAILFROM
 if  [ $? = 0 ]
 then
  echo Desbloqueando a $CORREO en ANTIVIRUS
#$SED -i "/${UVUS}@${DOMINIOUVUS}/d" $ficheroBADMAILFROM
  ssh root@antivirus1.int $SED -i "/${UVUS}@${DOMINIOUVUS}/d" $ficheroBADMAILFROM
  ssh root@antivirus1.int qmailctl restart
  ssh root@antivirus1.int propagar.sh -f badmailfrom
 else
  echo $CORREO No está bloqueado en ANTIVIRUS
 fi

