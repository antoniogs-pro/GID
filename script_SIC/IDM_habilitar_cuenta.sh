echo "User,waveset.accounts[DirectorioCorporativo\|PAS PDI].disabled,COMMAND" > enable.ba
#Ej. P:test0314,false,Update  # con la U de update en mayuscula
# habilita y cambia la clave también.
echo "$1",false,Update | tee -a enable.ba  
#

