#!/usr/bin/awk -f

#LINESPERRECORD=1
#COL1=T.D.,1,1,4
#COL2=DOCUMENTO,1,5,15
#COL3=NOMBRE,1,20,32
#COL4=APELLIDO1,1,52,32
#COL5=APELLIDO2,1,84,32
#COL6=CLAVE,1,116,15
#COL7=SEXO,1,131,1
#
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }
BEGIN {
# whatever
}
# Cuerpo del código principal
{
#Ejemplos
#split($1,ap," ");
#UID = tolower(substr($2,1s,1))tolower(ap[1])"-ext";
#print  "D",substr($3,1,8),toupper($2),toupper(ap[1]),toupper(ap[2]),"usSIOU2014",tolower($5),$4,UID;
tdoc="P"
documento="doc"
nombre="nombre"
ap1="apuno"
ap2="apdos"
clave="clave"
tdoc=substr($1,1,1);
documento=trim(substr($1,6,16));
nombre=toupper(trim(substr($1,21,33)));
ap1=toupper(trim(substr($1,53,33)));
ap2=toupper(trim(substr($1,85,33)));
clave=trim(substr($1,118,16));
sexo=substr($1,137,1);
print tdoc,documento,nombre,ap1,ap2,clave,sexo;
}
END {
# whatever
} 
