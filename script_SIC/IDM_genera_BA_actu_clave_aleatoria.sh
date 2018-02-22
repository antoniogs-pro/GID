#!/bin/bash 
# BA genera de contraseña "aleatoria"
#echo command,user,password.password,password.confirmPassword,password.selectAll > ficheroatratar.ba
#cat ficheroatratar.csv | cut -d, -f12 | tr "," ":" | IDM_genera_BA_actu_clave_aleatoria.sh 
#
echo command,user,password.password,password.confirmPassword,password.selectAll > ficheroatratar.ba
while read ndoc ; do
echo update,"$ndoc","us17&${ndoc:6:2}ES","us17&${ndoc:6:2}ES","true"
done | tee -a ficheroatratar.ba
echo  Proceso finalizado generado BA en fichero ficheroatratar.ba >&2

