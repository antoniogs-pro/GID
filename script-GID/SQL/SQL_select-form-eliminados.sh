#! /bin/bash
if [ ! "$1" == "" ]; then
BUSCAR=$1
(sqlline -u jdbc:oracle:thin:@bdgid.us.es:1492:gid -n ldap -p sevldap0608  -d oracle.jdbc.OracleDriver 2> errores.tmp << sql
!sql select * from uids_eliminados 
where uvus like '%$BUSCAR%'
or  ndoc like '%$BUSCAR%' ;
! quit
sql
) > fichero.tmp
 grep "^|" fichero.tmp
mv  fichero.tmp ~/.papelera
mv  errores.tmp ~/.papelera
else
echo No ha introducido dato requerido
echo "Sintaxis: $0 UVUS o documento  (no necesita estar completo)"
fi
