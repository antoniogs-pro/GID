USR=$1
EXTRAE=$SICSCRIPTS/extrae.pl

# echo $USR |
#
while read USR 
do
if [ ! "$USR" == "" ] ; then  
perl $EXTRAE  -f irisPersonalUniqueID=$USR -nodn -a schacpersonaluniqueid -a uid -a cn -a inetuserstatus -a schacuserstatus -a mailuserstatus -a UsEsRelacion -a ou -a seealso -a UsEsCentro -a iplanet-am-user-account-life | sed -e s/urn:mace:terena.org:schac:personalUniqueID:es://g | sed -e s/urn:mace:terena.org:schac:userStatus:us.es://g
fi
done

