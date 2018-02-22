rama="Alumno"
rama="PAS PDI"
#echo Rama: $rama; read rama
recurso="accounts[DirectorioCorporativo\\|$rama]"
nuevafecha=2018/03/15
#echo Fecha $nuevafecha;read nuevafecha
nuevafecha=2018/12/31
#
#echo "User,accounts[Lighthouse].fechaValidez,$recurso.fechaValidez,Command"
#,$recurso.vinculacion"  
echo "User,$recurso.fechaValidez,Sexo,Command" | tee cambiarfecha.ba
while read tndoc
do
#  echo cambiando fecha a  $ndoc >&2 
  echo "$tndoc,$nuevafecha,NoEspecificado,update" | tee -a cambiarfecha.ba
# ,NoEspecificado
# echo "P:A6
done 

