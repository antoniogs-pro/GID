cat $1 | sed -e /^command/d > ~/tmp/$1.tmp
fuente=~/tmp/$1.tmp

echo "select TDOC,NDOC,UVUS FROM acc_ldap
where ndoc in("user > consulta.sql

for ndoc in $(cat $fuente | cut -d, -f3)
 do

   echo ",""'""$ndoc""'" >> consulta.sql
 done
echo ");" >> consulta.sql
rm $fuente
 


