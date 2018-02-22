# generar LDIF
echo Generando fichero LDIF para actualización en LDAP
> Activar_Alumno.ldif
cat UVUS_alumnos_inactivos.txt | while read usuario
do
 if [ "$usuario" == "FIN" ]; then 
 break
 fi
 if [ !  "$usuario" == "" ]; then 
 echo >> Activar_Alumno.ldif
 echo "dn: uid=$usuario,o=alum.us.es,dc=us,dc=es" >> Activar_Alumno.ldif
 echo "changetype: modify">>Activar_Alumno.ldif
 echo "replace: inetUserStatus">>Activar_Alumno.ldif
 echo "inetUserStatus: Active">>Activar_Alumno.ldif
 fi
done
