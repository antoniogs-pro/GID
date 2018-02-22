cat $1 | sed -e /^command/d > ~/tmp/$1.tmp
fuente=~/tmp/$1.tmp

echo "select TDOC,NDOC,UVUS FROM acc_ldap
where uvus in("user > consulta.sql

for uvus in $(cat $fuente | cut -d, -f3)
 do

   echo ",""'""$uvus""'" >> consulta.sql
 done
echo ");" >> consulta.sql
rm $fuente
 
