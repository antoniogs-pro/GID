#rama="Alumno"
rama="PAS PDI"
#recurso="accounts[MaquetaDirectorio\\|$rama]"
recurso="accounts[DirectorioCorporativo\\|$rama]"
#,accounts[DirectorioCorporativo\|PAS PDI].mailSecundario
ndoc=$1
imaa=$2
fichero=$1
ficheroBA=cambiar-imaa.ba
echo "User,$recurso.mailSecundario,Command" | tee $ficheroBA
cat $fichero | sed -e '1d' | cut  -d, -f1,20 --output-delimiter=" "| while read ndoc imaa
do
  echo "$ndoc,$imaa,update" | tee -a $ficheroBA
done 

