EXTRAE=$SICSCRIPTS/extrae.pl
$EXTRAE -nodn -b o=us.es,dc=us,dc=es -f "(& (UsEsCargo=Director Dpto*) (UsEsRelacion=pdi) (InetUserStatus=Active))"  -a UsEsCargo -a IrisMailMainAddress | tee Directores_DPTO | wc -l
