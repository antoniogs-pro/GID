#! /bin/bash
# modificado 16/04/2015
# PARA PRO DEJAR EN BLANCO LA VARIABLE PRE
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
   echo $CPRE  $BUSCAR >&2
#
(sqlline -u jdbc:oracle:thin:@bdsevius$PRE.us.es:1492:svus$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2> $TMP/errores.tmp << sql
! autocommit off
!sql select FECHA,TDOC,NDOC,NOM,AP1,AP2,RELACIONES,NACIMIENTO,EMAIL,MOVIL FROM ldp_perfil_dif  
# NDOC like '%$BUSCAR%'
 where  NDOC = '$BUSCAR';
sql
) > $TMP/fichero.tmp
#
   grep "^|" $TMP/fichero.tmp

   if  [ $? = 1 ] ;  then
      echo  No existe $BUSCAR en la T.I.
      exit 255 
     fi 

# seguro que quiere actualizarle la fecha
   echo 
   echo update ldp_perfil_dif  set fecha=sysdate  where  NDOC="'$BUSCAR' ;"
   echo "commit;"
   echo
   echo -n ATENCIÓN Seguro que quiere hacer un SYSDATE al registro asociado a  $BUSCAR  '(S/N)?'
   TECLA=t
   while  [ $TECLA != S -a  $TECLA != N -a $TECLA != s -a  $TECLA != n ] ; do
	read TECLA
   done
   if [ $TECLA = S -o $TECLA = s ] ; then
	echo Realizando SYSDATE .....
#  aquí código de Sysdate
(sqlline -u jdbc:oracle:thin:@bdsevius$PRE.us.es:1492:svus$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2>> $TMP/errores.tmp << sql
!autocommit off
!sql select FECHA,TDOC,NDOC,NOM,AP1,AP2,RELACIONES,NACIMIENTO,EMAIL,MOVIL FROM ldp_perfil_dif  where  NDOC = '$BUSCAR';
!sql update ldp_perfil_dif  set fecha=sysdate  where  NDOC='$BUSCAR';
!commit;
!sql select FECHA,TDOC,NDOC,NOM,AP1,AP2,RELACIONES,NACIMIENTO,EMAIL,MOVIL FROM ldp_perfil_dif  where  NDOC = '$BUSCAR';
sql
) >> ~/.sqlline/modificados.lst

   fi
(sqlline -u jdbc:oracle:thin:@bdsevius$PRE.us.es:1492:svus$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2> $TMP/errores.tmp << sql
! autocommit off
!sql select FECHA,TDOC,NDOC,NOM,AP1,AP2,RELACIONES,NACIMIENTO,EMAIL,MOVIL FROM ldp_perfil_dif  where  NDOC = '$BUSCAR';
sql
) > $TMP/fichero.tmp

   grep "^|" $TMP/fichero.tmp

# else de si hay argumentos
   mv  $TMP/fichero.tmp ~/.papelera
   mv  $TMP/errores.tmp ~/.papelera
else
	echo  Ayuda
	echo .
	echo	 NO  ha introducido DATO REQUERIDO
	echo .
	echo     Sintaxis: $0 Nºde documento 
	echo	- el dato a buscar necesita estar completo.
	echo	- si usa la opción -p la busqueda se hará en Maqueta
	echo .

fi
