#!/bin/bash 
# Actualizaciones
#echo 'User,waveset.roles,accounts[Lighthouse].fechaValidez,[DirectorioCorporativo\|PAS PDI].fechaValidez,Command'>actufecha.ba
#D:28824219,|Merge|PROFESORSECUNDARIA,2013/12/01,2013/12/01,Update
# Altas
#echo "user,DocumentType,global.dni,global.firstname,global.apellido1,global.apellido2,waveset.roles,password.password,password.confirmPassword,password.selectAll,Sexo,accounts[DirectorioCorporativo\|PAS PDI].fechaValidez,accounts[Lighthouse].fechaValidez,command,accounts[DirectorioCorporativo\|PAS PDI].mailSecundario,accounts[DirectorioCorporativo\|PAS PDI].vinculacion"

# extrae.pl -f irisPersonalUniqueID=$ndoc -a uid  -nodn | tee -a USUARIOs.ldap
# El fichero .csv tendrá el formato 
# D,27299292,JOSE MARIA,GONZALEZ-SERNA,SANCHEZ,pA712uS99,glezserna@gmail.com,2017/11/25

isdirectory() {
  [ -d "$1" ]
}
isfile() {
  [ -f "$1" -a -s "$1" ]
}
BorrarFicherosVacios() {
for fichero in * ; do if [ -f "$fichero" -a ! -s "$fichero" ] ; then rm  $fichero;fi ; done
}
anio=$(date +"%Y")
FICHERO=$1
NUEVAFECHA=$2 # '$anio/11/20'
ARBOL="-b o=us.es,dc=us,dc=es"
RAMA="pas"
RELACION=$3  #PROFESORSECUNDARIA O MISCELANEA (AACCSS) o ALUMNOSECUNDARIA
COLECTIVO="PAU"
EXTRAE=$SICSCRIPTS/extrae.pl
LOG=bitacora.log
#
> $LOG
#
if  isfile "alta.csv" ; then
rm alta.csv
fi 
# echo "user,DocumentType,global.dni,global.firstname,global.apellido1,global.apellido2,waveset.roles,password.password,password.confirmPassword,password.selectAll,Sexo,accounts[DirectorioCorporativo\|PAS PDI].fechaValidez,accounts[Lighthouse].fechaValidez,command,accounts[DirectorioCorporativo\|PAS PDI].mailSecundario,accounts[DirectorioCorporativo\|PAS PDI].vinculacion"
> cambiaran_de_UVUS.txt
#
if [ ! -f "$FICHERO" ]
then
 echo "Falta o no existe fichero de datos origen - $FICHERO - " >&2
 echo " El contenido del fichero tendrá el formato TDOC,ndoc,Nueva_Fecha_vencimiento,RELACION" >&2
 echo " Los datos Fecha_vencimiento,RELACION  son opcionales si son comunes y se aportan como parámetros al script" >&2
 
 exit 255
fi
#
if [ "$NUEVAFECHA" = "" ]
then
 echo "Falta 2º dato obligatorio NUEVA FECHA 'aaaa/11/20'"  >&2
 #NUEVAFECHA='$anio/11/25'
 exit 255
fi
#
if [ "$RELACION" = "" ]
then
 echo Falta 3º dato obligatorio relación, usando valor por defecto PROFESORSECUNDARIA  >&2
 RELACION=PROFESORSECUNDARIA
 #exit 255
fi
#
if [ "$RELACION" = "ALUMNO" -o "$RELACION" = "ALUMNOSECUNDARIA" -o "$RELACION" = "EXALUMNO" -o "$RELACION" = "ALUMNOEEPP" ]
  then
RAMA="alum"
fi
#
if [ "$RAMA" = "pas" ]
  then
   RAMA="PAS PDI"
   ARBOL="-b o=us.es,dc=us,dc=es"
  else
   if [ "$RAMA" = "alum" ]
    then
     RAMA="Alumno"
     ARBOL="-b o=alum.us.es,dc=us,dc=es"
    else 
     RAMA=""
   fi
 fi
if [ "$RAMA" = "" ]
then
 echo "Falta dato obligatorio Relación " >&2
 exit 255
fi
RECURSO="accounts[DirectorioCorporativo\\|$RAMA]"
if [ "$4" = "pre" -o "$4" = "PRE" ]
then
	RECURSO="accounts[MaquetaDirectorio\\|$RAMA]"
        EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
else
	RECURSO="accounts[DirectorioCorporativo\\|$RAMA]"
fi


# echo "Command,User,accounts[Lighthouse].fechaValidez,$RECURSO.fechaValidez,waveset.roles" > ${FICHERO}.ba

for TNDOC in $(cat $FICHERO | cut -d, -f1,2 | tr "," ":")
 do
USUARIOALUM=$($EXTRAE -b o=alum.us.es,dc=us,dc=es  -f "(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${TNDOC})" -nodn  -a uid  -a UsEsRelacion -a iplanet-am-user-account-life -a ou  | sed -e 's/,dc=us,dc=es//g' -e 's/urn:mace:terena.org:schac:personalUniqueID:es://g'  -e 's/urn:mace:terena.org:schac:userStatus:us.es://g')
#echo $USUARIOALUM
USUARIOUSES=$($EXTRAE  -b o=us.es,dc=us,dc=es -f "(schacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${TNDOC})" -nodn   -a uid  -a UsEsRelacion  -a iplanet-am-user-account-life -a ou  | sed -e 's/,dc=us,dc=es//g'  -e 's/urn:mace:terena.org:schac:personalUniqueID:es://g'  -e 's/urn:mace:terena.org:schac:userStatus:us.es://g')
#echo $USUARIOUSES
#
UVUSACTUAL=$(echo $USUARIOUSES |cut -d "|" -f 1)
if [ "$UVUSACTUAL" == "" -a "$USUARIOALUM" == "" ];then
  echo "El usuario $TNDOC no existe " >> $LOG
  grep "$(echo $TNDOC  | cut -d ":" -f 2)" $FICHERO >> alta.csv
else
 if [ "$UVUSACTUAL" == "" ];then
  echo el usuario $TNDOC  cambiara de UVUS, el actual es $(echo $USUARIOALUM  |cut -d "|" -f 1) >> cambiaran_de_UVUS.txt
  grep "$(echo $TNDOC  | cut -d ":" -f 2)" $FICHERO >>  agregarrelacion.csv
 else
  IPLANET=$(echo $USUARIOUSES |cut -d "|" -f 3)
  if [ ! "$IPLANET" == "" ]; then
   ACTUAL=$(echo "$IPLANET" |sed -e 's/\///g')
   NUEVA=$(echo "$NUEVAFECHA" |sed -e 's/\///g')
   if [ $ACTUAL -gt $NUEVA ]; then
    echo El usuario $TNDOC tiene Fecha de vencimiento mayor que la nueva, se le mantiene la actual $IPLANET >> $LOG
    NUEVAFECHA=$IPLANET
   else 
    echo El usuario $TNDOC actualizará la  Fecha a $NUEVAFECHA >> $LOG
    echo "update,$TNDOC,$NUEVAFECHA,$NUEVAFECHA"',|Merge|'"$RELACION" >> ${FICHERO}.dat
   fi
  fi
 fi
fi
done 
# if [ -f ${FICHERO}.ba -a -s ${FICHERO}.ba ] ; then
if isfile "${FICHERO}.dat" ; then
echo "Command,User,accounts[Lighthouse].fechaValidez,$RECURSO.fechaValidez,waveset.roles" > actualizar.ba 
cat  ${FICHERO}.dat >> actualizar.ba  &&  rm ${FICHERO}.dat
fi
#
if isfile "alta.csv" ; then
echo Seleccione $COLECTIVO en el siguiente menú
sleep 3
BA.sh alta.csv  # 7 colectivo PAU
fi
#if ! isfile "cambiaran_de_UVUS.txt" ; then
#rm cambiaran_de_UVUS.txt
#fi
BorrarFicherosVacios

