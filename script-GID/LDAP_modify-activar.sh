# Activar
password=%,yntqy.
ldapmodify -H ldap://ldap1.int -D "cn=directory manager" -w "$password" -x -f Activar_Alumno.ldif | tee usuarios_activados.log
#
