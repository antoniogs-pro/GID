#/bin/bash
# para generar ficheros de BA para alumnossecundaria
clear
RUTA=~/SIC/script_SIC
if [ "$SICSCRIPTS" == "" ]
then
RUTA=~/SIC/script_SIC
else
RUTA=$SICSCRIPTS
fi
echo Ejecutando $0 
fi=$1
fo=fi.ba
echo  depurar_caracteres_no_imprimibles 
$RUTA/depurar_caracteres_no_imprimibles.sh $fi

if [ $? -gt 0 ] ; then
echo Error $?
exit 1
fi

echo llamando a $RUTA/genera-bulkaction.pl 
echo Se generará  $PWD/$fo 

# las fecchas de validez serán AAAA/11/20 y AAAA+1/02/20 para cada curso escolar donde AAAA sera por ejemplo 2014
perl $RUTA/genera-bulkaction.pl -e $1 -c ALUMNOSECUNDARIA -f 2016/11/20 > $fo 
echo Fichero $PWD/$fo generado


