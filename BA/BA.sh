#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: 
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado:
#
# Como usarlo
# echo "Como usarlo:  " $0 fichero CSV
########################################################################

# Notas aclaratorias
# las fecchas de validez serán:
#
# Para ICC-Grados y Masters
#	AAAA/11/20 y AAAA+1/02/20 para cada curso escolar donde AAAA sera por ejemplo 2017
# Para A6
#	AAAA/03/31 donde AAAA será el año siguiente
# Para ERASMUS 
#	las fechas de validez serán  AAAA+1/03/15 para cada curso escolar donde AAAA sera por ejemplo 2015
#	para curso 2014/2015 y  AAAA/11/30 para la segunda remesa (posteriores a marzo)
# Para PAU, AACCSS, Alumnos secundaria (COMPLEJO AÚN NO TERMINADOS SCRIPT)
#	 siempre AAAA/11/30
# Para exalumnos
#	 siempre AAAA+2/11/20
# FECHAS que vienen en fichero
# Para FIUS la fecha viene en fichero de entrada
# Para PDIEXTERNO la fecha debe venir en fichero de entrada
# CSIC    -f 2019/05/02
#
#
#
#######################################
#Variables de entorno impresindibles  #
#######################################
#
if [ -n "$BASH_ENV" ]; then . "$BASH_ENV" ;fi
#if [ -n "$BASH_ENV" ]; then . "$BASH_ENV" ; else ( if [ -f  $FUNPROC/entorno.sh ]; then . $FUNPROC/entorno.sh; fi ); fi
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
LOGFILE=$LOGDIR/BA.log
unset FICHEROENTRADA
FICHEROENTRADA="$1"
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
#echo Ejecutando $0 sobre $1
#
# COMPROBACIONES SOBRE EL FICHERO DE ENTRADA
#
if [ "${FICHEROENTRADA}" == "" ]
then
cat >&2 << :ayuda
	 ATENCIÓN: 
	 Debe especificar el nombre del FICHERO de ENTRADA tipo texto (CSV)  a procesar.
	 sintaxis:
	 $0 nombre_FICHERO
:ayuda
exit 255
fi
#
if [ ! -f "${FICHEROENTRADA}" ]
then
cat >&2 << :ayuda
	 ATENCIÓN: 
	 No existe el ficheo $FICHEROENTRADA	
	 sintaxis:
	 $0 nombre_FICHERO
:ayuda
 exit 254
fi

# RETIRAR el PATH, espacios en blanco y extensión del NOMBRE DEL FICHERO
#

echo -=== normalizando fichero  ====-  $FICHEROENTRADA >> $LOGFILE
nombre=$(echo $FICHEROENTRADA | tr " "  "_")
[  $FICHEROENTRADA = $nombre ] ||  cp "$FICHEROENTRADA" $nombre
FICHEROENTRADA=$nombre
camino='.'
camino=`dirname ${FICHEROENTRADA}`
cd $camino
FICHEROENTRADA=`basename ${FICHEROENTRADA}`
extencion=${FICHEROENTRADA##*.}
FICHEROSALIDA=${FICHEROENTRADA%.$extencion}
FICHEROATRATAR=ficheroatratar.csv
# pendiente como usar $nombre
#
#
##################################################################################
##############################
# PROCESO		     #
##############################
# pendiente de mejorar, con case y tablas
#
#colectivos
declare  Acolectivo=(NINGUNO GRADOS MASTER EXALUMNO PDIEXTERNO ERASMUS UNIVERSIDAD-EXT PAU AACCSS ALUMNOSECUNDARIA PROFESORSECUNDARIA CSIC A6 FIUS PASEUOSUNA EXT IBIS  AulaExperiencia MAES)
typeset -i Indice
Indice=0
Ncolectivos=${#Acolectivo[@]}
while true ; do
clear
echo 
echo ==========================================================
for (( Indice=0; Indice<=$((Ncolectivos - 1)); Indice+=1 )); do
echo -e  "\t $Indice ${Acolectivo[$Indice]} "
done
echo ==========================================================
echo

read -n2  -p " Indique colectivo y pulse enter, ${Acolectivo[0]}  para salir :" opt

if [  $opt -lt 0 -o $opt -gt $((Ncolectivos - 1))  -o "$opt" = ""  ] ; then
echo "Opción erronea, intentelo de nuevo"
else
#echo $opt
break
fi
done
echo
echo ==========================================================
colectivo=${Acolectivo[$opt]}
seleccion=${Acolectivo[$opt]}
echo “Seleccionaste colectivo $seleccion ”
echo
echo ==========================================================
#Si el usuario elige finalizar el programa, entonces abandonamos script.
    if [ "$seleccion" = "NINGUNO" -o "$seleccion" = "" ]; then
      echo “El colectivo es un dato necesario, Abandonando script” ; exit 1
    fi

cuentas_ya_UVUS="noprocesar"

# Selección 
case $seleccion in
"NINGUNO" | "")
echo “El colectivo es un dato necesario, Abandonando script” ; exit 1
;;
"ALUMNOSECUNDARIA")
#Año en curso
fValidez=2017/11/20 # SECUNDARIA
 sed -i  /"TDOC,DOC,ALNOMBRE,ALAPELL1,ALAPELL2,CLAVE"/d ${FICHEROENTRADA}
colectivo=$seleccion
RELACION=ALUMNOSECUNDARIA
;;
"PROFESORSECUNDARIA" | "PAU" )
#Año en curso
fValidez=2017/11/25 # "PROFESORSECUNDARIA"| "PAU" | "AACCSS" | "MAES" 
RELACION=PROFESORSECUNDARIA
colectivo=$seleccion
;;
"MAES")
#Año en siguiente
annio=2018
fValidez=$annio/09/30  # "PROFESORSECUNDARIA" "MAES" 
RELACION=PROFESORSECUNDARIA
colectivo=$seleccion
#cuentas_ya_UVUS="noprocesar"
;;
"AACCSS" | "ADMCS")
#Año en curso
fValidez=2017/11/25 # | "AACCSS" | "ADMCS"
RELACION=MISCELANEA
if  [ "$colectivo" == "AACCSS" ]; then
colectivo="ADMCS"
fi
if  [ "$colectivo" == "ADMCS" ]; then
echo  Quitando de UVUS eliminados los UVUS de ADM.Sec que se van a crear.
echo Generando sentencia SQL
echo 'select * from uids_eliminados where uvus in ( '>sql
cat ${FICHEROENTRADA} | cut -d, -f2 | while read i; do echo -n "'"$i"'"; echo  "," ; done >> sql
echo ')'>>sql
fi
;;
"A6") # A6
fValidez=2018/03/31 # A6
RELACION=MISCELANEA
colectivo=$seleccion
;;
"ERASMUS") # ERASMUS
annio=2018
#fValidez=AAAA/03/15 # ERASMUS AAAA año en curso para 2º semestre
fValidez=$annio/03/15 # ERASMUS AAAA año en curso +1 para 2º semestre
RELACION=ALUMNOSECUNDARIA
colectivo=$seleccion
cuentas_ya_UVUS="noprocesar"
;;
"FIUS") # FIUS
fValidez=""   # FIUS 
RELACION=MISCELANEA
cuentas_ya_UVUS="procesar"
colectivo=$seleccion
;;
"GRADOS")  # "GRADOS"
#fValidez=2017/02/20 #  GRADOS
fValidez=2017/11/30 #  GRADOS
RELACION=ALUMNOSECUNDARIA
colectivo=GRADOS
cuentas_ya_UVUS="noprocesar"
;;
"AulaExperiencia")  # "AulaExperiencia"
fValidez=2017/11/30 #  AulaExperiencia
RELACION=ALUMNOSECUNDARIA
colectivo=AulaExperiencia
cuentas_ya_UVUS="noprocesar"
;;
"MASTER")
fValidez=2018/02/20 # MASTERS
RELACION=ALUMNOSECUNDARIA
colectivo=MASTER
cuentas_ya_UVUS="noprocesar"
;;
"EXALUMNO")
fValidez=2018/11/20 # EXALUMNO
colectivo=$seleccion
;;
"PDIEXTERNO") # PDIEXTERNO
fValidez=""   # PDIEXTERNO fecha incluida en fichero
colectivo=$seleccion
RELACION=PDIEXTERNO
cuentas_ya_UVUS="noprocesar"
;;
"UNIVERSIDAD-EXT")
fValidez=""   #  viene en fichero de entrada
fValidez="2020/31/12"
RELACION=MISCELANEA
colectivo="UNIVERSIDADES"
cuentas_ya_UVUS="noprocesar"
;;
"CSIC")
fValidez=2019/09/05 #  CSIC
RELACION=MISCELANEA
colectivo=CSIC
cuentas_ya_UVUS="noprocesar"
;;
"FIUS")
fValidez=""   # FIUS viene en fichero de entrada
RELACION=MISCELANEA
colectivo=$seleccion
;;
"PASEUOSUNA")
fValidez=""   #  viene en fichero de entrada
RELACION=MISCELANEA
colectivo=PASEUOSUNA
;;
"EXT")
fValidez=""   #  viene en fichero de entrada
RELACION=MISCELANEA
colectivo=EXT
;;
"IBIS")
fValidez=""   #  viene en fichero de entrada
RELACION=MISCELANEA
colectivo=IBIS
#cuentas_ya_UVUS="noprocesar"
cuentas_ya_UVUS="procesar"
;;
*)
mensaje="Opción erronea, El colectivo es un dato necesario, Abandonando script"; exit 1
;;
esac
#
#

if  [ "$colectivo" == "" ]; then
cat << :ayuda
	 ATENCIÓN: 
	 Debe especificar el nombre del colectivo a procesar.
:ayuda
exit 255
fi

# Control y relación de cuentas que ya tenian UVUS
# RAMA
RAMA="pas"
if [ "$RELACION" = "ALUMNO" -o "$RELACION" = "ALUMNOSECUNDARIA" -o "$RELACION" = "EXALUMNO"  -o "$RELACION" = "ALUMNOEEPP" ]
  then
RAMA="alum"
else
RAMA="pas"
fi
if [ "$RAMA" = "" ]
then
 echo Falta dato obligatorio RAMA "(alum o pas)" >&2
 exit 255
fi
ARBOL="-b o=us.es,dc=us,dc=es"
if [ "$RAMA" = "pas" ]
  then
   RAMALDAP="PAS PDI"
   ARBOL="-b o=us.es,dc=us,dc=es"
  else
   if [ "$RAMA" = "alum" ]
    then
     RAMALDAP="Alumno"
     ARBOL="-b o=alum.us.es,dc=us,dc=es"
    else 
     RAMALDAP=""
   fi
 fi
RECURSO="accounts[DirectorioCorporativo\\|$RAMALDAP]"
if [ "$4" = "pre" ]
then
	RECURSO="accounts[MaquetaDirectorio\\|$RAMALDAP]"
else
	RECURSO="accounts[DirectorioCorporativo\\|$RAMALDAP]"
fi
export RAMA ARBOL RECURSO
#
# Pasos realizados por el siguiente script
# 1º Convertir a UTF-8 sin BOM,  $RUTA/2utf8.sh ${FICHEROENTRADA}
# 2º control de retorno de carros linux, $RUTA/2retornoscarro-lf.sh  ${FICHEROENTRADA}
# 3º Depurando caracteres no válidos en  ${FICHEROENTRADA} genera ${FICHEROATRATAR}
$FUNPROC/depurar_caracteres_no_imprimibles.sh ${FICHEROENTRADA}
if [ $? -gt 0 ] ; then
echo Error $? $error
exit 1
fi
if [ ! -f ${FICHEROATRATAR} -o ! -s ${FICHEROATRATAR} ]
  then
cat << :error
	 ATENCIÓN: 
	 Ha habido errores al preparar el fichero a tratar. No existe o está vacio
:error
exit 253
fi
#
# eliminando cuentas que ya tienen UVUS por otra relación cuando proceda
echo Buscando cuentas que ya poseen otra relación con La US en cualquier rama 
# entrecomillo $USR por si el documento viene con espacios en blanco
cat ${FICHEROATRATAR} | cut -d, -f 1,2| tr "," ":"| while read USR ; do  perl $EXTRAE -s "," -f "schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${USR}" -nodn -a schacpersonaluniqueid -a givenname -a sn1 -a sn2 -a uid -a UsEsRelacion -a ou | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g; done | tee YA_tenian_uvus_otra_relacion.ldap | wc -l
#
> encontrados-en-LDAP.csv
if [ $cuentas_ya_UVUS == "noprocesar" ] ; then
> encontrados-en-LDAP.csv
for tndoc in $(cat YA_tenian_uvus_otra_relacion.ldap | sed -e s/"|"/,/g | tr ":" ","| cut -d"," -f2  )
do
 grep $tndoc  ${FICHEROATRATAR} >> encontrados-en-LDAP.csv
 sed -i  /"$tndoc"/d ${FICHEROATRATAR}
done
fi

#
echo .
echo " Crea cuentas que ya tienen UVUS:" '?' $cuentas_ya_UVUS 
echo $mensaje
echo $fValidez
#
echo Ejecutando Shell para lanzar generador BA para crear cuentas de colectivo $colectivo con fecha de vencimiento ${fValidez:-"para cada usuario"} 
#
#
# GENERAR LA BA
#
if [ ! "$fValidez" == "" ]
then
FECHA="-f ""$fValidez"
fi
#
# Activar la generación para maqueta (pre-produccion) si el segundo argumento es p
# PRE="-pre"
# echo llamando a $RUTA/genera-bulkaction.pl  -c $colectivo  $FECHA , Se generará  $PWD/${FICHEROSALIDA}.ba
#if ["$2"=="-p" -o "$2"=="-P" ]; then perl $RUTA/genera-bulkaction.pl    -pre  -c $colectivo  $FECHA > ${FICHEROENTRADA}-pre.ba; fi
#
if [ ! -f ${FICHEROATRATAR} -o ! -s ${FICHEROATRATAR} ]
  then
cat << :error
	 ATENCIÓN: 
	 Ha habido errores al preparar el fichero a tratar. No existe o está vacio
:error
exit 253
fi
#

perl $RUTA/genera-bulkaction.pl   -c $colectivo  $FECHA > ${FICHEROSALIDA}.ba
echo
echo Se ha generado $PWD/${FICHEROSALIDA}.ba 
echo
#
# COMPROBACIONES Y NOTAS FINALES
#
echo 'buscando caracteres que NO (^) estén en el rango especificado '
cat ${FICHEROSALIDA}.ba |sed -e 1d  | grep  [^0-9A-Za-z:.,_' ''@''/'\/\|\-] | tee repasar-caracteres-en-BA

###

echo Listado de usuarios eliminados de la BA porque ya tenian UVUS para $colectivo
cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh ${FICHEROSALIDA}.ba |  grep -v ",$" > Excluidos_en_BA_YA_tenian_uvus
cat  Excluidos_en_BA_YA_tenian_uvus | grep $RELACION > Excluidos_en_BA_YA_tenian_$RELACION
###
#
# eliminando cuentas que ya tienen UVUS
for tndoc in $(cat Excluidos_en_BA_YA_tenian_uvus |cut -d, -f1 )
do
 sed -i  /"$tndoc"/d ${FICHEROSALIDA}.ba
done
 cp  ${FICHEROSALIDA}.ba  NO_tenian_uvus.ba
cat << :recordar

 Antes de lanzar la BA, recordar:
	- hojear ${FICHEROSALIDA}.ba para ver si hay caracteres raros y ver si cumple el formato esperado.
        - No olvide comprobar mayúsculas los campos nombre,ape1,ape2
	- probar primero con el primer usuario, si todo va bien el resto
	- Seleccionar en acción: de lista de acciones
	-  == OJO ==  aumentar a $(cat ${FICHEROSALIDA}.ba | wc -l ) el Máximo de resultados por página
:recordar
##


##
if  [ "$colectivo" == "PAU" ]; then
echo "Command,User,waveset.roles,accounts[DirectorioCorporativo\|PAS PDI].fechaValidez,accounts[Lighthouse].fechaValidez,accounts[DirectorioCorporativo\|PAS PDI].vinculacion" > agregarrelacion.ba
awk -v OFS="," -F"," '{print  "Update",toupper($1)":"$2,"|Merge|PROFESORSECUNDARIA",$8,$8,"MAES";}' agregarrelacion.csv >> agregarrelacion.ba
echo        - para obtener los UVUS ejecutar despues: 
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh| sed s/" "/_/g | tee ${FICHEROSALIDA}+UVUS.csv" > obtener-UVUS_$colectivo.sh 

#echo "cat agregarrelacion.ba |sed -e 1d | cut -d, -f 1 | while read BDOC; do perl /home/sic/SIC/script_SIC/extrae.pl -b o=us.es,dc=us,dc=es -s , -nodn  -f schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:$BDOC -a schacpersonaluniqueid -a givenname -a sn1 -a sn2 -a uid -a UsEsRelacion  | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g | sed s/" "/_/g  >> agregarrelacion+UVUS.csv; done" >> obtener-UVUS_$colectivo.sh 
echo Para obtener los UVUS ejecute el script -    "bash" './' "obtener-UVUS_$colectivo.sh"
fi
#
if  [ "$colectivo" == "PDIEXTERNO" ]; then
echo "command,user,waveset.roles,accounts[DirectorioCorporativo\|PAS PDI].fechaValidez,accounts[Lighthouse].fechaValidez,accounts[DirectorioCorporativo\|PAS PDI].vinculacion,accounts[DirectorioCorporativo\|PAS PDI].mailSecundario" > agregarrelacion.ba
awk -v OFS="," -F"," '{print  "Update",toupper($1)":"$2,"|Merge|'${RELACION}'",$6,$6,$7,$8;}' agregarrelacion.csv >> agregarrelacion.ba
echo        - para obtener los UVUS ejecutar despues: 
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh| sed s/" "/_/g | tee ${FICHEROSALIDA}+UVUS.csv" > obtener-UVUS_$colectivo.sh 

echo "cat agregarrelacion.ba |sed -e 1d | cut -d, -f 1 | while read BDOC; do perl /home/sic/SIC/script_SIC/extrae.pl -b o=us.es,dc=us,dc=es -s , -nodn  -f schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:$BDOC -a schacpersonaluniqueid -a givenname -a sn1 -a sn2 -a uid -a UsEsRelacion  | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g | sed s/" "/_/g  >> agregarrelacion+UVUS.csv; done" >> obtener-UVUS_$colectivo.sh 
echo Para obtener los UVUS ejecute el script -    "bash" './' "obtener-UVUS_$colectivo.sh"
fi
##
if  [ "$colectivo" == "IBIS" ]; then
cat << :recordar
   Los UVUS están integrados en la petición, no hay que obtenerlos

:recordar
fi
if  [ "$colectivo" == "FIUS" ]; then  # para colectivos con prefijo en NDOC
cat << :recordar
 Los UVUS están integrados en la petición, no hay que obtenerlos
:recordar
fi
if  [ "$colectivo" == "EXT" ]; then  # para colectivos con prefijo en NDOC
cat << :recordar
 Los UVUS están integrados en la petición, no hay que obtenerlos
:recordar
fi
if  [ "$colectivo" == "A6" ]; then  # para colectivos con prefijo en NDOC
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1  | bash $RUTA/LDAP_obtener_UVUS_decolectivo.sh $colectivo  | tee ${FICHEROSALIDA}+UVUS.csv" > obtener-UVUS_$colectivo.sh
cat << :recordar
        - para obtener los UVUS ejecutar despues: 
    cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1  | bash $RUTA/LDAP_obtener_UVUS_decolectivo.sh $colectivo  | tee ${FICHEROSALIDA}+UVUS.csv
:recordar
fi
if  [ "$colectivo" == "GRADOS" ]; then
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh  | tee ${FICHEROSALIDA}+UVUS.csv " > obtener-UVUS_$colectivo.sh 
cat << :recordar
        - para obtener los UVUS ejecutar despues: 
 cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh  | tee ${FICHEROSALIDA}+UVUS.csv
:recordar
fi
if  [ "$colectivo" == "MASTER" ]; then
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh  | tee ${FICHEROSALIDA}+UVUS.csv " > obtener-UVUS_$colectivo.sh 
cat << :recordar
        - para obtener los UVUS ejecutar despues: 
 cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh  | tee ${FICHEROSALIDA}+UVUS.csv
:recordar
fi
if  [ "$colectivo" == "ERASMUS" ]; then
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh  | tee ${FICHEROSALIDA}+UVUS.csv" > obtener-UVUS_$colectivo.sh 
cat << :recordar
        - para obtener los UVUS ejecutar despues: 
 cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh  | tee ${FICHEROSALIDA}+UVUS.csv
:recordar
fi




if  [ "$colectivo" == "MISCELANEA" ]; then   # "ADMCS"
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh | tee ${FICHEROSALIDA}+UVUS.csv" > obtener-UVUS_$colectivo.sh 
cat << :recordar
        - para obtener los UVUS ejecutar despues: 
  cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1 | bash $RUTA/LDAP_obtener_UVUS_desde_tndoc.sh | tee ${FICHEROSALIDA}+UVUS.csv
:recordar
fi

if  [ "$colectivo" == "CSIC" ]; then
echo "cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1  | bash $RUTA/LDAP_obtener_UVUS_decolectivo.sh $colectivo  | tee ${FICHEROSALIDA}+UVUS.csv" > obtener-UVUS_$colectivo.sh
cat << :recordar
        - para obtener los UVUS ejecutar despues: 
    
    cat ${FICHEROSALIDA}.ba |sed -e 1d | cut -d, -f 1  | bash $RUTA/LDAP_obtener_UVUS_decolectivo.sh $colectivo  | tee ${FICHEROSALIDA}+UVUS.csv
:recordar
fi
# fin
