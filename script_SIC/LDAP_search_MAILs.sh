#[root@buzon ~]# cat /usr/local/bin/listado_usuarios_ldap.sh 
#!/bin/bash
#
# Este proceso crea un listado MAILs de todos los usuarios de ldap en la fecha de hoy
# Javi
#!/bin/bash

FECHA=`date +%Y%m%d`
LDAPSRV=192.168.4.123
LDAPSRVpasswd='%,yntqy.'
LDPAMaqueta=192.168.4.99
LDPAMaquetapasswd='pqeecdsm'
LDAPSVR=$LDPAMaqueta
PASSWD=$LDPAMaquetapasswd
ruta="$HOME/SIC/Gestion_correo_y_ddv"
FICHERODESTINO=$ruta/MAILs_$FECHA.txt
#
touch -m $FICHERODESTINO
#
/usr/bin/ldapsearch -D "cn=directory manager" -w $PASSWD -x -h $LDAPSVR -b o=us.es,dc=us,dc=es \
	"(&(inetUserStatus=Active)(mailUserStatus=Active))" mail | grep "^mail:" | cut -d ":" -f 2 >> $FICHERODESTINO
echo creado fichero $FICHERODESTINO



