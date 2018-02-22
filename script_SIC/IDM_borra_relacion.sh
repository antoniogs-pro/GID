rama="Alumno"
#rama="Pas Pdi"
recurso="accounts[DirectorioCorporativo\\|$rama]"
nuevafecha=2015/02/25
#,A6"
echo "User,waveset.roles,Command"
#,$recurso.vinculacion"  

while read ndoc
do
#  echo Eliminando relación $RELACION  a  $ndoc >&2
  echo "$ndoc,|Remove|MISCELANEA,update"

done 




