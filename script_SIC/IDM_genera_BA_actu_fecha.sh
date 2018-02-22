#!/bin/bash 
#echo 'User,accounts[Lighthouse].fechaValidez,accounts[DirectorioCorporativo\|Alumno].fechaValidez,Command'>USUARIOs.ba
#D:28824219,2013/12/01,2013/12/01,Update
# extrae.pl -f irisPersonalUniqueID=$ndoc -a uid  -nodn | tee -a USUARIOs.ldap
# PTE. El fichero tendrá el formato Doc:ndoc,Nueva_Fecha,Rama o mejor relacion
FICHERO=$1
NUEVAFECHA=$2
RAMA=$3
EXTRAE=$SICSCRIPTS/extrae.pl

if [ ! -f "$FICHERO" ]
then
 echo Falta fichero de datos origen - $FICHERO - >&2
 exit 255
fi

NUEVAFECHA=$2
if [ "$NUEVAFECHA" = "" ]
then
 echo "Falta 2º dato obligatorio NUEVA FECHA 'aaa/mm/dd'" >&2
 exit 255
fi
RELACION=$3
if [ "$RELACION" = "" ]
then
 echo Falta 3º dato obligatorio relación  >&2
fi
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
RECURSO="accounts[DirectorioCorporativo\\|$RAMA]"
if [ "$4" = "pre" ]
then
	RECURSO="accounts[MaquetaDirectorio\\|$RAMA]"
else
	RECURSO="accounts[DirectorioCorporativo\\|$RAMA]"
fi


echo "User,accounts[Lighthouse].fechaValidez,$RECURSO.fechaValidez,Command" > actufecha.ba

for TNDOC in $(cat $FICHERO)
 do

#$EXTRAE  $ARBOL -f "chacPersonalUniqueID=urn:mace:terena.org:schac:personalUniqueID:es:${TNDOC}" -nodn -a schacpersonaluniqueid -a irisPersonalUniqueID -a uid  -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a seealso -a ou -a UsEsCentro -a iplanet-am-user-account-life | sed -e s/,dc=us,dc=es//g | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g

  echo "$TNDOC,$NUEVAFECHA,$NUEVAFECHA,Update"
done | tee -a actufecha.ba






