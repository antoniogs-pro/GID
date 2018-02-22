#!/bin/bash 
USUARIO=$1
NUEVAFECHA=$2
RAMA=$3
RAMA=pas
echo $USUARIO > $TMPDIR/docsatratar; $SICSCRIPTS/IDM_genera_BA_actu_fecha.sh $TMPDIR/docsatratar $NUEVAFECHA $RAMA
