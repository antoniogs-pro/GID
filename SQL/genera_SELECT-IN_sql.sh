#!/bin/bash
########################################################################
# Autor: Antonio González
# Proposito del script: Generador SQL SELECT
#
# Última actualización: 2017/01/25
## Ultimo cambio realizado: Posibilidad de ejecutar directamente la orden
#
########################################################################
# Como usarlo
echo "Como usarlo: cat fichero" '|' "$0"
#
#Variables de entorno impresindibles
export SIC=$HOME/SIC
export SICSCRIPTS=$SIC/script_SIC
export TMPDIR=~/tmp
local  ffecha=$(date -I)
echo ${ffecha}
# PARA PRO DEJAR EN BLANCO LA VARIABLE PRE
PRE=
TMPDIR=~/tmp
if [ "$1" == "-p"  ]; then
   PRE=2
   CPRE="   ATENCION: BUSCANDO EN MAQUETA "
   EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
   PREoPRO='-P'
   shift
else
   PRE=''
   CPRE="  BUSCANDO EN PRODUCCIÓN " 
   EXTRAE=$SICSCRIPTS/extrae.pl
fi
if [ "$2" == "-p"  ]; then
   CPRE="   ATENCION: BUSCANDO EN MAQUETA " 
   PRE=2
   EXTRAE=$SICSCRIPTS/extrae-maqueta.pl
  PREoPRO='-P'
fi
#
echo $CPRE  
#
orden='SELECT '
tabla='ldp_perfil_dif'
datos=''
# tdoc='"'"P"'" 'AND 
condicion='where '
condicion=$condicion' ndoc in ('"'"USER"'"
ordenacion='ORDER BY tdoc,ndoc '
echo 1º Generando $orden iN
echo Generando sentencia_$orden.sql
if [ "$datos"="" ]
 then
  echo 'SELECT * ' >cabecera_SELECT.sql
 else
  echo 'SELECT  ' >cabecera_SELECT.sql
  echo $datos >> cabecera_SELECT.sql
fi
echo "FROM $tabla" >> cabecera_SELECT.sql 

>condicion_SELECT.sql
if [ ! "$condicion" = "" ]
 then
   echo $condicion  >condicion_SELECT.sql
#
  while read USUARIO
  do
# ojo NO METER NINGÚN READ EN EL BUCLE
       if [ "$USUARIO" = "FIN" ]; then
         exit 1
       fi
       if [ ! "$USUARIO" = "" ]
         then
          echo ",""'""$USUARIO""'" >> condicion_SELECT.sql
         else 
            exit 1
       fi
  done
 echo ')'>> condicion_SELECT.sql
fi
cat cabecera_SELECT.sql condicion_SELECT.sql > sentencia_SELECT.sql
if [ ! "$ordenacion" == "" ]
 then
   echo  $ordenacion >> sentencia_SELECT.sql
fi

echo ';' >> sentencia_SELECT.sql
cat sentencia_SELECT.sql
# Pa nota
#Generar fichero resultado de consulta
echo   ATENCIÓN quiere ejecutar la consulta SQL SELECT IN   '(S/N)?'
   TECLA=t
   while  [ $TECLA != S -a  $TECLA != N -a $TECLA != s -a  $TECLA != n ] ; do
	read TECLA
   done
 if [ $TECLA == S -o $TECLA == s ] ; then
echo  ejecutando SQL
(sqlline -u jdbc:oracle:thin:@bdsevius$PRE.us.es:1492:svus$PRE -n ldap -p sevldap0608 -d oracle.jdbc.OracleDriver 2> $TMPDIR/errores.tmp << sql
!sql `cat sentencia_SELECT.sql`
! quit
sql
) > $TMPDIR/fichero.tmp
echo  Fin ejecutar SQL
 fi
rm cabecera_SELECT.sql ; rm condicion_SELECT.sql
#
#Generar csv
echo  ATENCIÓN generando fichero .CSV asociado a los datos de la consulta. Creando fichero resultado_select_${ffecha}.csv .....
# convertir a CSV
       grep "^| 2" $TMPDIR/fichero.tmp |sed -e s/\ //g|sed -e s/^\|//g|sed -e s/\|$//g|sed -e s/\|/,/g > resultado_select_${ffecha}.csv
#

