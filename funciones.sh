#!/bin/bash
# Script de funciones genericas de entorno
# incluirlas en los script con llamada en propio shell  , nunca incluirlo en bashrc
#!/bin/bash
# . funciones.sh
#
# Verificaciones
function isvpn()
{
IFVPN=$(ifconfig | grep "tun" | cut -d " " -f 1)
if [ "$IFVPN" = "" ]
then
 echo .·: ----------------------------------:·.
 echo . " El estado  de las VPN esta desactivado ... "  .
 echo ·.: ----------------------------------:.·
  if [ "$DISPLAY" == ":0" ] ; then
     zenity --error --timeout=5 --title="Error - ARMAR LA vpn" --text=" Recuerda ARMAR la VPN,"
     notify-send --urgency=low "Interfaces VPN  $IFVPN  DesActivas"
  fi
export VPNstatus=off
     exit 255
else 
   echo Interfaces VPN  $IFVPN  Activas
fi
}
return 0 ;
#
# VPNs
function upvpn()
{
. ~/bin/vpn.sh 
export VPNstatus=ON
}
return NULL ;
#
function downvpn()
{
isvpn;
if [ $? = 255 ]; then
echo " El estado  de las VPN ya está desactivado ..."
else
. ~/bin/vpn.sh stop
fi
}
return NULL ;
#
### Funciones de entorno
function uc()
{
    echo "${*^^}"  # * por ser usado dentro de una función 
   # echo "${1^^}"  #  debe de ir en realidad el nombre de la variable si se usa directamente en un script 1 para $1
}

function lc()
{
     echo "${1,,*}"
}
return NULL ;
#
# Las dos anteriores funcionan con cualquier alfabeto, son por ello las mejores opciones
function mayusculas()
{
    echo "$1" | awk '{print toupper($0)}'
}
return NULL ;
#
function minusculas()
{
    echo "$1" | awk '{print tolower($0)}'
}
return NULL ;
#
function 2uppercase()
{
#    echo "$1" | tr 'a-z' 'A-Z'
    echo "$1"| tr  '[:lower:]' '[:upper:]'
}
return NULL ;
#
function 2lowercase()
{
#    echo "$1" | tr 'A-Z' 'a-z'
    echo "$1"| tr '[:upper:]' '[:lower:]'
}
return NULL ;
#
isdirectory() {
  [ -d "$1" ]
}
isfile() {
  [ -f "$1" -a -s "$1" ]
}
#

