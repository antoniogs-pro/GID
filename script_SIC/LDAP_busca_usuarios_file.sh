>$1_ya_existen.rpt
for TNDOC in $(cat $1 | cut -d, -f1)
do
echo Buscando $TNDOC
echo "$TNDOC" | $SICSCRIPTS/LDAP_busca_TNDOC.sh | tee -a $1_ya_existen.rpt
done
wc -l $1_ya_existen.rpt
