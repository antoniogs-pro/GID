#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: Restaurar bandeja de buzon desde bacula
#
# Última actualización: 2017/06/28
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
FICHEROENTRADA="$1"
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
# ============================
#entorno específico
BUZON="buzonus.int"
ficheroDENY=/etc/dovecot/deny
ANTIVIRUS="antivirus1.int"
ficheroBADMAILFROM=/etc/postfix/bloqueados
bitacora=$LOGDIR/recupera_buzon.log
CORREO=$1
#
if [ $# -eq 0 ]; then
 echo Debe especificar la direccion de correo a tratar
 exit 255
fi
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

echo $CORREO > $bitacora
#
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
(ssh -i $LLAVE root@$BUZON /usr/local/bin/estado_buzon.sh ${CORREO}) |tee -a  $bitacora
# . BUZON_estado.sh $cuenta | tee -a $bitacora
#
buzones=$(cat $bitacora | grep "^mdbox:")
indice=$(cat $bitacora | grep "^mdbox:"| cut -d":" -f3|cut -d"=" -f2)
buzonprincipal=$(cat $bitacora | grep "^mdbox:"| cut -d":" -f2)
alternativo=$(cat $bitacora | grep "^mdbox:"| cut -d":" -f4|cut -d"=" -f2)
#echo $indice
#echo $buzonprincipal
#echo $alternativo
#echo $buzones
bandeja=INBOX
#select bandeja INBOX Trash Sent
echo en bacula ejecutar | tee -a $bitacora 
echo bconsole y luego comandos messages y quit | tee -a $bitacora
echo luego lanzar Bacula con comando bat | tee -a $bitacora
echo ver si hay algún job corriendo | tee -a $bitacora
echo rellenar datos a recuperar marcando en la parte derecha $UVUS en las rutas siguientes | tee -a $bitacora
echo $alternativo | tee -a $bitacora 
echo $buzonprincipal | tee -a $bitacora
echo $indice | tee -a $bitacora 
echo ver evcorreo-backup-correo para ver si llega el mensaje de que ha terminado o bien ir refrescando jobs run | tee -a $bitacora
#
echo ssh -X root@backup_virtual.int | tee -a $bitacora 


#
echo conectamos a buzones  $BUZON  Para restaurar con los comando siguientes | tee -a $bitacora
#
echo Nº de mensajes totales ; grep "Cuota de usuario MESSAGE" $bitacora | tee -a $bitacora
echo Nº de mensajes actualmente en la bandeja $bandeja , 'doveadm search -u' $UVUS 'mailbox' $bandeja '| wc -l' | tee -a $bitacora
#
#Restaurar
echo  para restaurar | tee -a $bitacora
echo primero cambiamos el ID de usuaruio  su entrega  | tee -a $bitacora
echo para recuperar una bandeja | tee -a $bitacora
echo doveadm -v import -u $UVUS $buzones '""' mailbox $bandeja | tee -a $bitacora
echo Para recuperar todo, ojo la carpeta que le crea debemos borrarla nosotros | tee -a $bitacora
echo doveadm import -s -u $UVUS $buzones restaurado_$(date -I) all | tee -a $bitacora
echo recuperar id root con orden exit | tee -a $bitacora
#
echo Nº de mensajes tras restauración | tee -a $bitacora
echo  en la bandeja $bandeja:  'doveadm search -u' $UVUS 'mailbox' $bandeja '| wc -l' | tee -a $bitacora
echo totales: /usr/local/bin/estado_buzon.sh ${CORREO} | tee -a $bitacora

echo  ssh root@$BUZON | tee -a $bitacora
#

echo enviamos e-mail al usuario | tee -a $bitacora
cat  << :email
Asunto: recuperado la copia de seguridad solicitada de la cuenta $CORREO
Buenas,
le comunicamos que se ha recuperado la copia de seguridad solicitada de la cuenta $CORREO, esperamos que esté todo correcto.
Si tiene algún problema no dude en contactar de nuevo con nosotros.
Reciba un cordial saludo
:email

mv $bitacora $LOGDIR/recupera_buzon${CORREO}.log
# Fin del script

