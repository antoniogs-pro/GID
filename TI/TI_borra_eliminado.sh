#! /bin/bash
# PARA PRO DEJARA EN BLANCO LA VARIABLE PRE
GREP=/bin/grep
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
(sqlline -u jdbc:oracle:thin:@bdgid$PRE.us.es:1492:gid$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2> $TMP/errores.tmp << sql
!sql select * from uids_eliminados where uvus = '$BUSCAR' ;
! quit
sql
) > $TMP/fichero.tmp
   #grep "^|" $TMP/fichero.tmp 
   grep "^|" $TMP/fichero.tmp | grep "$BUSCAR" 

    if  [ "$?" = "1" ] ;  then
     
      echo  No existe $BUSCAR en UVUS eliminados
      exit 255 
     fi 
  

# seguro que quiere borrarlo

   echo ATENCIÓN Seguro que quiere liberar el UVUS  $BUSCAR  '(S/N)?'
   TECLA=t
   while  [ $TECLA != S -a  $TECLA != N -a $TECLA != s -a  $TECLA != n ] ; do
	read TECLA
   done
   if [ $TECLA = S -o $TECLA = s ] ; then
	echo Borrando .....
#  aquí código de borrar
(sqlline -u jdbc:oracle:thin:@bdgid$PRE.us.es:1492:gid$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2>> $TMP/errores.tmp << sql
!sql delete from uids_eliminados where
 uvus = '$BUSCAR' ;
! commit;
! quit
sql
) >> ~/.sqlline/borrados.lst
   fi
 mv  $TMP/fichero.tmp ~/.papelera
 mv  $TMP/errores.tmp ~/.papelera
# else de si hay argumentos
else
	echo ayuda
	echo .
	echo 	 NO  ha introducido DATO REQUERIDO
	echo .
	echo     Sintaxis: $0 documento 
	echo 	- el documento a buscar necesita estar completo.
	echo	- si usa la opción -p la busqueda se hará en Maqueta
	echo .
fi

