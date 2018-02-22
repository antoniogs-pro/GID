> Activar_usuarios.ldif
while read usuario
do
 if [ "$usuario" == "FIN" ]; then 
 exit 1
 fi
 if [ !  "$usuario" == "" ]; then 
 echo >> Activar_usuarios.ldif
 echo "dn: uid=$usuario,o=alum.us.es,dc=us,dc=es" >> Activar_usuarios.ldif
 echo "changetype: modify">>Activar_usuarios.ldif
 echo "replace: inetUserStatus">>Activar_usuarios.ldif
 echo "inetUserStatus: Active">>Activar_usuarios.ldif
 fi
done


