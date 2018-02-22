# Generador SQL
fichero=$1
echo 3º Quitando de UVUS eliminados los UVUS que se van a crear.
echo Generando sentencia select.sql
echo 'select * from uids_eliminados where ndoc in ( '>select.sql
cat $fichero | cut -d, -f9 | while read i; do echo -n "'"$i"'"; echo  "," ; done >> select.sql
echo ')'>>select.sql

echo 'delete  from uids_eliminados where tdoc='P' and  ndoc in ( '>delete.sql
cat $fichero | cut -d, -f9 | while read i; do echo -n "'"$i"'"; echo  "," ; done >> delete.sql
echo ')'>>delete.sql

