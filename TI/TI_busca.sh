#! /bin/bash
# PARA PRODUCCION DEJARA EN BLANCO LA VARIABLE PRE
PRE=''
TMP=~/tmp
if [ "$1" == "-p"  ]; then
   PRE=2
   CPRE="   ATENCION: BUSCANDO EN MAQUETA "
   shift
else
   PRE=''
   CPRE="  BUSCANDO EN PRODUCCIÓN " 
fi
if [ "$2" == "-p"  ]; then
   CPRE="   ATENCION: BUSCANDO EN MAQUETA " 
   PRE=2
fi
#
if [ ! "$1" == "" ]; then
   BUSCAR=$1
   echo $CPRE  $BUSCAR 
(sqlline -u jdbc:oracle:thin:@bdsevius$PRE.us.es:1492:svus$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2> $TMP/errores.tmp << sql
!sql select FECHA,TDOC,NDOC,NOM,AP1,AP2,RELACIONES,NACIMIENTO,EMAIL,EMAIL2,MOVIL FROM ldp_perfil_dif 
 where  NDOC like '%$BUSCAR%'
 or
      email like '%$BUSCAR%';
! quit
sql
) > $TMP/fichero.tmp
   grep "^|" $TMP/fichero.tmp
#   mv  $TMP/fichero.tmp ~/.papelera
#   mv  $TMP/errores.tmp ~/.papelera
else
	echo  Ayuda
	echo .
	echo	 NO  ha introducido DATO REQUERIDO
	echo .
	echo     Sintaxis: $0 UVUS o documento 
	echo	- el dato a buscar no necesita estar completo.
	echo	- si usa la opción -p la busqueda se hará en Maqueta
	echo .

fi
