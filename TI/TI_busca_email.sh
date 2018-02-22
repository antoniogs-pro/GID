#! /bin/bash
# PARA PRO DEJARA EN BLANCO LA VARIABLE PRE
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
   BUSCAR=$(echo "$1" | sed 's/\(.*\)/\L\1/g')
   BUSCARM=$(echo "$1" | sed 's/\(.*\)/\U\1/g')
   echo $CPRE  $BUSCAR 
# !set outputformat csv
(sqlline -u jdbc:oracle:thin:@bdsevius$PRE.us.es:1492:svus$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2> $TMP/errores.tmp << sql
!brief
!record t
!sql select TDOC,NDOC,NOM,AP1,AP2,RELACIONES,NACIMIENTO,EMAIL,MOVIL FROM ldp_perfil_dif 
 where email like '%$BUSCAR%';
! quit
sql
) > $TMP/fichero.tmp
   grep "^|" $TMP/fichero.tmp

cat $TMP/fichero.tmp

grep "No rows selected" $TMP/errores.tmp
if [ $? = 0 ] ; then
echo $CPRE  $BUSCARM 
# !set outputformat csv
(sqlline -u jdbc:oracle:thin:@bdsevius$PRE.us.es:1492:svus$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2> $TMP/errores.tmp << sql

!sql select TDOC,NDOC,NOM,AP1,AP2,RELACIONES,NACIMIENTO,EMAIL,MOVIL FROM ldp_perfil_dif 
 where email like '%$BUSCARM%';
! quit
sql
) > $TMP/fichero.tmp
   grep "^|" $TMP/fichero.tmp

grep "No rows selected" $TMP/errores.tmp
fi

   mv  $TMP/fichero.tmp ~/.papelera
   mv  $TMP/errores.tmp ~/.papelera
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
