#!/bin/bash
####################################################################################
# Autor: Antonio González
# Proposito del script: 
# Fichero para crear alias y variables asociadas a comandos 
#
# Última actualización: 2017/06/28
## Ultimo cambio realizado:
#  agregado alias
#  
# Como usarlo
# echo "Como usarlo:  " . $0  "  OJO al punto para ejecutar en shell actual
####################################################################################
# # Aliases asociadas a Ordenes
. ~/bin/.bash_aliases
# # Variables asociadas a Ordenes
SED=/bin/sed
GREP=/bin/grep
MUTT=/usr/bin/mutt
ECHO=/usr/bin/echo
CAT=/usr/bin/cat
CURL=/usr/bin/curl
UNIQ=/usr/bin/uniq
WC=/usr/bin/wc

#!/usr/bin/awk -f
AWK=/usr/bin/awk
# Propias
EXTRAE=$SICSCRIPTS/extrae.pl
MAQUETA=$SICSCRIPTS/extrae-maqueta.pl
BA=$SICSCRIPTS/genera-bulkaction.pl
#
SYSFECHA=`date  "+%Y_%m_%d"`
SYSFECHAHORA=`date  "+%Y_%m_%d_%r"`
