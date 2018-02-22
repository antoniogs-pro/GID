#!/usr/bin/perl
# Script perl para obtener datos básicos y formateados de LDAP
#ejemplo uid=lacruz,o=alum.us.es,dc=us,dc=es|urn:mace:terena.org:schac:personalUniqueID:es:D:00812881, nombre+apellidos
$clave="La_clave_es_secreta";
$entrada="dump_usuarios_ldap";
$salida ="Datos.ldap";
# $entrada SE OBTIENE CON ESTE COMANDO: perl extrae.pl -nodn -a schacPersonalUniqueID -a cn > $entrada
# LDAP_dump.pl > $entrada ;
open(IN,"<$entrada") or die("No puedo abrir el fichero $entrada !\n");
open(OUT,">$salida") or die("No puedo abrir el fichero Salida !\n");
%mapa = ();
while (<IN>) {
    chomp($_);
    @linea= split(/\|/,$_);


    $doc = $linea[0];
    $doc =~ s/urn:mace:terena.org:schac:personalUniqueID:es://;
    $doc =~ s/urn:mace:terena.org:schac:userStatus:us.es://;


    $NombreCompleto = $linea[1];
    $Ap1 = $linea[2];
    $Ap2 = $linea[3];
    $Nom = $linea[4];

    $uvus = $linea[5];
    $mapa{$doc} = $uvus;


    $inetuserstatus = $linea[6];
    $UVUS_status = $linea[7];
    $UVUS_status =~ s/urn:mace:terena.org:schac:userStatus:us.es:uvus:/Uvus-/;
    $Mail_status = $linea[8];
    $Relacion = $linea[9];
    $Relacion =~ s/,/·/; 
    $seealso = $linea[10];
    $ou = $linea[11];
    $Centro = $linea[12];
    $Fvencimiento = $linea[13];
#
    $uvus = $linea[14];
    $uvus =~ s/uid=//;
    $uvus =~ s/,o=alum.us.es,dc=us,dc=es//;
    $uvus =~ s/,o=us.es,dc=us,dc=es//;
    $uvus =~ s/,dc=us,dc=es//;
    $Uid = $linea[15];
    $Uid =~ s/urn:mace:terena.org:schac:personalUniqueID:es://;
    $Uid =~ s/urn:mace:terena.org:schac:userStatus:us.es://;

# Salida de datos formateada a STDOUT y hacia fichero de salida
# ejemplo  print "$doc,$NombreCompleto,$mapa{$doc},$clave\n";
   print "$doc,$NombreCompleto,$mapa{$doc}\n";
   print OUT "$doc,$NombreCompleto,$mapa{$doc},Ldap-$inetuserstatus,$UVUS_status,Mail-$Mail_status,$Relacion,$ou,$seealso,$Fvencimiento\n";
} 
  close (IN);
  close (OUT);


