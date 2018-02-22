#!/bin/bash 
# BA cambio de contraseña
#command,user,password.password,password.confirmPassword,waveset.roles,global.firstname,global.apellido1,global.apellido2,Sexo,global.dni,accounts[DirectorioCorporativo\|Alumno].vinculacion
#CreateOrUpdate,D:00000030,abcd1234,abcd1234,,,,,,,
# 
#
#
#echo Ejecutando $0 sobre $1
#
# Cargar el entorno
#
. $SICSCRIPTS/FUNCYPROC/entorno.sh
#
TMP=~/mnt
LOG=~/SIC/log/BA.log
SYSFECHA=`date  "+%Y_%m_%d"`
SYSFECHAHORA=`date  "+%Y_%m_%d_%r"`
#
RUTA=$SICSCRIPTS
if [ "$SICSCRIPTS" == "" ]
then
RUTA=~/SIC/script_SIC
fi
#
#comandos
#
#!/usr/bin/awk -f
AWK=/usr/bin/awk
SED=/bin/sed
GREP=/bin/grep
#

FICHEROENTRADA=$1

if [ "$FICHEROENTRADA" = "" ]
then
 echo 'Debe especificar FICHERO a taratar como 1º argumento' >&2
exit 255
fi
if [ ! -s $FICHEROENTRADA ]
then
 echo 'Debe especificar FICHERO a taratar que exista y no esté vacio' >&2
exit 255
fi
#
# RETIRAR el PATH, espacios en blanco y extensión del NOMBRE DEL FICHERO
#
echo === normalizando fichero  ====  $FICHEROENTRADA >> $LOG
nombre=$(echo $FICHEROENTRADA | tr " "  "_")
cp "$FICHEROENTRADA" $nombre
FICHEROENTRADA=$nombre

camino='.'
camino=`dirname ${FICHEROENTRADA}`
cd $camino
FICHEROENTRADA=`basename ${FICHEROENTRADA}`
extencion=${FICHEROENTRADA##*.}
FICHEROSALIDA=${FICHEROENTRADA%.$extencion}


# pendiente como usar $nombre


#
#
RAMA=${2:-"alum"}
echo Rama: $RAMA
if [ "$RAMA" = "" ]
then
 echo 'Debe especificar la RAMA como 2º argumento. Opciones posibles son: pas o bien alum' >&2
exit 255
fi
if [ "$RAMA" = "pas" ]
  then
   RAMA="PAS PDI"
  else
   if [ "$RAMA" = "alum" ]
    then
     RAMA="Alumno"
    else 
     RAMA=""
   fi
 fi
#
RECURSO=$3
if [ "$RECURSO" = "" ]
then
 RECURSO="accounts[DirectorioCorporativo\\|$RAMA]"
fi
if [ "$RECURSO" = "pre" ]
then
	RECURSO="accounts[MaquetaDirectorio\\|$RAMA]"
else
	RECURSO="accounts[DirectorioCorporativo\\|$RAMA]"
fi

#
echo Procesando ${FICHEROENTRADA}
$RUTA/FUNCYPROC/depurar_caracteres_no_imprimibles.sh ${FICHEROENTRADA}

if [ $? -gt 0 ] ; then
echo Error $? $error
exit 1
fi
if [ ! -f ficheroatratar.csv ]
  then
cat << :error
	 ATENCIÓN: 
	 Ha habido errores al preparar el fichero a tratar
:error
exit 253
fi
FICHEROSALIDA=${FICHEROENTRADA}.ba


echo  En Proceso generando BA .. >&2

# FIJATE que TRUE está en minúsculas y Update con la U en mayúsculas ES IMPORTANTE
# formato para admin delegada
#echo "command,user,password.password,password.confirmPassword,password.selectAll,waveset.roles,global.firstname,global.apellido1,global.apellido2,global.dni,Sexo,$RECURSO.vinculacion" > ficheroatratar.ba
#awk -F "," -v OFS="," '{print "Update",$1,$2,$2,",,,,,","Preinscripcion2018 clave"}'  $FICHERO | tee -a ${FICHEROSALIDA}
# formato para grupo correo
echo command,user,password.password,password.confirmPassword,password.selectAll > ${FICHEROSALIDA}
awk -F "," -v OFS="," '{print "Update",$1,"us"$2,"us"$2,"true"}'  ficheroatratar.csv  | tee -a ${FICHEROSALIDA}
# Formato con clave "aleatoria"
#awk -F "," -v OFS="," '{print "Update",$1,"us17&"${1:6:2},"us17&"${1:6:2},"true"}'  $FICHERO | tee -a ${FICHEROSALIDA}
echo  Proceso finalizado generado BA en fichero ${FICHEROSALIDA} >&2


