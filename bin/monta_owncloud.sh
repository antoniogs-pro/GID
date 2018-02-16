# ! /bin/bash
USUARIO=$USER
PuntoMontaje=$HOME/DDV/
if [ ! "$1"=="" ]; then
 USUARIO=$1
fi
if [ ! "$2"=="" ]; then
 PuntoMontaje=$HOME/$2
fi
if [ ! -d $PuntoMontaje ]; then
 mkdir $PuntoMontaje
fi
# si no quiere tocar el fichero /etc/fstab
sudo  mount -t davfs  https://hdvirtual.us.es/discovirt/remote.php/webdav/ $PuntoMontaje  -o  uid=$USUARIO,gid=$USUARIO,rw 

# si a definido el montaje en /etc/fstab
# # Para OwnCloud
# https://hdvirtual.us.es/discovirt/remote.php/webdav/  /home/sic/DDV  davfs  rw,noexec,nosuid,owner 0 3
#
# sudo  mount $PuntoMontaje -o  uid=$USUARIO,gid=$USUARIO,rw 

