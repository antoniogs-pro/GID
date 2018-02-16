#!/usr/bin/perl
# Script para formar una bulk action a partir de un csv
# Autor: Víctor Téllez - vtellez-ext@us.es
# Incluye actualizaciones de Antonio González 2015/09
# Agregados nuevos colectivos: MASTERS, EXALUMNOS, DOCTORADO, UNIVERSIDADES EXTRANJERAS, ADMINISTRATIVOS  CENTROS DE SECUNDARIA, CUENTAS INSTITUCIONALES, PDIEXTERNOS
# Fecha del sistema y por defecto
# Adapatación a UTF-8, agregar la variable de entorno PERL_UNICODE=S o ejecute en línea de alguna de las siguientes formas
# $ PERL_UNICODE=S perl script.pl
# Ejecutar perl con la opción -CS   $ perl -CS script.pl
#
use Getopt::Long;
use Path::Class qw( file );
use File::Spec;
use utf8; # Usa UTF8 en el código
binmode(STDOUT, ":utf8");  # fuerza la salida de print en UTF8
# Comienzo
$| = 1;
STDOUT->autoflush(1);
$pre = '0'; # Por defecto
$entrada = 'ficheroatratar.csv';

# Obtener Fecha y hora del sistema
    my ($segundo,$minuto,$hora,$dia,$mes,$anio,$diaSemana) = (localtime(time))[0,1,2,3,4,5,6];

# Primero tomemos los valores de año asegurando que cuente con cuatro dígitos.
	$anio += 1900;
# Segundo tomemos los valores de día y mes, asegurando que cuenten con dos dígitos.
	$mes += 1;
	$dia = $dia < 10 ? '0' . $dia : $dia;
	$mes = $mes < 10 ? '0' . $mes : $mes;
	$mes = $mes < 1 ? '01' : $mes;
# Tercero formateamos la hora y la fecha.
    my $hora_sys = sprintf("%02d:%02d:%02d",$hora,$minuto,$segundo);
    my $fecha_sys = sprintf("%04d/%02d/%02d",$anio,$mes,$dia);
# Formatos para salida de mensajes
    my $fecha_hora = "Hoy es: $dias[$diaSemana] $dia de $meses[$mes] $mes  del $anio Hora: $hora_sys";


#
# Ayuda
if ($ARGV[0] eq '--help' or
	$ARGV[0] eq '-h'
	or !(@ARGV)
	) {
	&ayuda;
	exit 0;
}

# Parámetros de línea de Órdenes
if (! GetOptions("pre!"=>\$pre, # si o no
	   		"entrada=s" => \$entrada, # cadena	
            "colectivo=s" => \$colectivo, # cadena
            "fecha=s" => \$fecha, # cadena
          )) {
	  &ayuda;
	  exit 1;
}

if($colectivo eq "ALUMNOSECUNDARIA" || $colectivo eq "ERASMUS" || $colectivo eq "GRADOS"|| $colectivo eq "MASTER" || $colectivo eq "EXALUMNO" || $colectivo eq "ALUMNOEEPP" || $colectivo eq "AulaExperiencia" || $colectivo eq "ALUMNO")
{
    $rama = "Alumno";
}
elsif($colectivo eq "DOCTORADO")
{
    $rama = "PAS PDI";
    $anio += 2;
}
else
{
    $rama = "PAS PDI";
}

# Gestion de fechas por defecto

if($colectivo eq "ALUMNOSECUNDARIA")
      {
       # Fecha por defecto para colectivos Secundaria
         $mes = 11;
         $dia = 30;
      }
   elsif($colectivo eq "exalumno")
      {
       # Fecha por defecto para colectivos exalumno
	 $anio += 1;
         $mes = 11;
         $dia = 30;
      }	
else
{
# Año, Dia y mes por defecto 		
# $anio += 1;
 $mes = 12;
 $dia = 31;
#
}

if("$fecha" eq "")
{
$fecha = "$anio/$mes/$dia";
}



if ($ARGV[0] ne "") {
	print STDERR "Opciones desconocidas:\n";
	foreach (@ARGV) {
		print STDERR " $_\n";
	}
	&ayuda();
	exit 1;
}
# Abre el fichero convirtiendolo a UTF8
      open(my $fh, "<:encoding(UTF-8)", $entrada) || die "can't open UTF-8 encoded filename: $!"; 



if($pre)
{
	$recurso = "accounts[MaquetaDirectorio\\|".$rama."]";
}
else
{
	$recurso = "accounts[DirectorioCorporativo\\|".$rama."]";
}

$cabecera_comun = "user,DocumentType,global.dni,global.firstname,"."global.apellido1,global.apellido2,waveset.roles"
					.",password.password,password.confirmPassword,"
					."password.selectAll,Sexo,$recurso.fechaValidez,accounts[Lighthouse].fechaValidez,command";

if ($colectivo eq "A6")
{
	$cabecera_propia = ",$recurso.mailSecundario,$recurso.mobile,$recurso.vinculacion,"."estadoCorreo,$recurso.seeAlso";
	$ROL = "MISCELANEA";	
}
elsif ($colectivo eq "PDIEXTERNO")
{
#	$cabecera_comun = "user,DocumentType,global.dni,global.firstname,global.apellido1,global.apellido2,"."waveset.roles"
#
#			.",$recurso.fechaValidez,accounts[Lighthouse].fechaValidez,command";

	$cabecera_propia = ",$recurso.vinculacion,$recurso.mailSecundario";
	$ROL = "PDIEXTERNO";	
}
elsif ($colectivo eq "GIE")
{
	$cabecera_propia = ",$recurso.vinculacion";
	$ROL = "PDIEXTERNO";	
}
elsif ($colectivo eq "CSIC")
{
	$cabecera_propia = ",$recurso.vinculacion,$recurso.mailSecundario,$recurso.mobile,"."estadoCorreo,$recurso.seeAlso";
	$ROL = "MISCELANEA";	
}
elsif ($colectivo eq "EXT")
{
	$cabecera_propia = ",$recurso.vinculacion,$recurso.seeAlso,$recurso.mailSecundario".",$recurso.uid,$recurso.identity";
	$ROL = "MISCELANEA";
}
elsif ($colectivo eq "FIUS")
{
	$cabecera_propia = ",$recurso.vinculacion,$recurso.seeAlso,$recurso.mailSecundario".",$recurso.uid,$recurso.identity";
	$ROL = "MISCELANEA";
}
elsif ($colectivo eq "PASEUOSUNA")
{
	$cabecera_propia = ",$recurso.vinculacion,$recurso.seeAlso,$recurso.mailSecundario".",$recurso.uid, $recurso.identity";
	$ROL = "MISCELANEA";
}
elsif ($colectivo eq "UNIVERSIDADES")
{
	$cabecera_propia = ",$recurso.vinculacion,$recurso.seeAlso,$recurso.mailSecundario".",$recurso.uid,$recurso.identity";
	$ROL = "MISCELANEA";
}

elsif ($colectivo eq "IBIS")
{
	$cabecera_propia = ",$recurso.vinculacion,$recurso.seeAlso".",$recurso.uid,$recurso.identity,$recurso.mailSecundario";
	$ROL = "MISCELANEA";
}
elsif ($colectivo eq "INSTITUCIONAL")
{
	$cabecera_propia = ",$recurso.seeAlso,$recurso.vinculacion".",$recurso.uid,$recurso.identity,$recurso.mailSecundario";
	$ROL = "MISCELANEA";
}
elsif ($colectivo eq "PROFESORSECUNDARIA" || $colectivo eq "PAU" || $colectivo eq "MAES")
{
	$cabecera_propia = ",$recurso.mailSecundario,$recurso.vinculacion";
	$ROL = "PROFESORSECUNDARIA";
}
elsif ($colectivo eq "ADMCS")
{
	$cabecera_propia = ",$recurso.mailSecundario";
	$ROL = "PROFESORSECUNDARIA";
}
elsif ($colectivo eq "ALUMNOSECUNDARIA" || $colectivo eq "ERASMUS" || $colectivo eq "MASTER" || $colectivo eq "GRADOS" || $colectivo eq "AulaExperiencia")
{
	$cabecera_propia = ",$recurso.vinculacion";
	$ROL = "ALUMNOSECUNDARIA";
}
elsif ($colectivo eq "EXALUMNO")
{
     $cabecera_comun = "user,DocumentType,global.dni,global.firstname,"."global.apellido1,global.apellido2,waveset.roles"
					.",password.password,password.confirmPassword,"
					."password.selectAll,Sexo,$recurso.fechaValidez,command";
	$cabecera_propia = "";
	$ROL = "EXALUMNO";
}
elsif ($colectivo eq "DOCTORADO")
{
	$cabecera_propia = ",$recurso.vinculacion,$recurso.seeAlso,$recurso.uid,$recurso.identity";
	$ROL = "MISCELANEA";	
}
else
{
	&ayuda(); exit 1;
}




print "$cabecera_comun"."$cabecera_propia"."\n";


while (<$fh>)
{
	chomp($_);

	$_ =~ s/\s+,/,/; 
	$_ =~ s/,\s+/,/;
	$_ =~ s/[ÁáÄäÃÀÁàÂâÃã]/a/g;
	$_ =~ s/[ÉéËëÈÈèÊê]/e/g;
	$_ =~ s/[ÍíÏïÎîÌì]/i/g;
	$_ =~ s/[ÓóÖöÔôÒòÕõ]/o/g;
	$_ =~ s/[ÚúÜüÙùÛû]/u/g;

	#Caracteres que se eliminan
	$_ =~ s/[']//g;

	#Otras sustituciones
	$_ =~ s/[Þ]/p/g;
	$_ =~ s/[Çç]/c/g;
	$_ =~ s/[Ññ]/n/g;
        $_ =~ s/[ž]/z/g;	
	$_ =~ s/[ª]/aria /g;
	$_ =~ s/[º]/ /g;

	@lista = split(/,/,$_);

	if ($colectivo eq "A6")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS,$MAIL,$TEL) = @lista;
		
		$NDOC = $colectivo.uc($NDOC);
		$TDOC = "P";

		$VINCULACION = "A6";
		$MAIL_STATUS = "Active";
		$SEEALSO = "\"uid=dtari,o=us.es,dc=us,dc=es\"";

		$cuerpo = ",$MAIL,$TEL,$VINCULACION,$MAIL_STATUS,$SEEALSO";
	}
	elsif ($colectivo eq "PDIEXTERNO") # Personal Investigador
 	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$fecha,$VINCULACION,$MAIL) = @lista;
	# $PI="PI";
	# $NDOC = $PI.$TDOC.$NDOC;
	# $TDOC = "P";
	# $FECHA = 
         $PASS="ECDCen24H".$mes.$dia;
#         $VINCULACION = "Dpto. "."$VINCULACION";
          $VINCULACION = "$VINCULACION";
		
		$cuerpo = ",".uc($VINCULACION).",$MAIL";
	}
	elsif ($colectivo eq "GIE")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS) = @lista;
		$VINCULACION = "GIE ".uc($TDOC).":".uc($NDOC);
		$NDOC = $colectivo.$NDOC;
		$TDOC = "P";
		$cuerpo = ",$VINCULACION";
		$fecha=$fecha_val;
	}
	elsif ($colectivo eq "CSIC")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS,$MAIL,$TEL) = @lista;
#		$VINCULACION = "Investigador CSIC ".uc($TDOC).":".$NDOC;
		$VINCULACION = "CSIC ".uc($TDOC).":".$NDOC;

		$NDOC = $colectivo.$NDOC;
		$TDOC = "P";		
		$MAIL_STATUS = "Active";
		$SEEALSO = "\"uid=infoscis,o=us.es,dc=us,dc=es\"";
		$cuerpo = ",$VINCULACION,$MAIL,$TEL,$MAIL_STATUS,$SEEALSO";		
	}
	elsif ($colectivo eq "EXT")
	{
		($UID,$EMPRESA,$TDOC,$NDOC,$NOM,$AP1,$AP2,$FECHA_EXT,$ALSO,$MAIL,$PASS) = @lista;
#		$UID = $UID."-ext";
		$VINCULACION = uc($EMPRESA)." ".uc($TDOC).":".uc($NDOC);
#		$NDOC = $colectivo.$NDOC;
		$NDOC = $UID;
		$TDOC = "P";		
		$SEEALSO = "\"uid=".$ALSO.",o=us.es,dc=us,dc=es\"";
		
       		$fecha = $FECHA_EXT;
#		$PASS = "ForpaS-2017";
		$cuerpo = ",$VINCULACION,$SEEALSO,$MAIL,$UID,\"uid=$UID,o=us.es,dc=us,dc=es\"";		
	}
	elsif ($colectivo eq "FIUS")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS,$FECHA_FIUS,$MAIL,$UID,$EXT) = @lista;

		$VINCULACION = "FIUS ".uc($TDOC).":".uc($NDOC);
		$NDOC = $colectivo.$NDOC;
		$TDOC = "P";		
		$SEEALSO = "\"uid=vtt,o=us.es,dc=us,dc=es\"";
		$UID = $UID."-ext";
       		$fecha = $FECHA_FIUS;
	
		$cuerpo = ",$VINCULACION,$SEEALSO,$MAIL,$UID,\"uid=$UID,o=us.es,dc=us,dc=es\"";		
	}
	elsif ($colectivo eq "PASEUOSUNA")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS,$FECHA_osuna,$MAIL,$UID,$ALSO) = @lista;

		$VINCULACION = "EUOSUNA: ".uc($TDOC).":".uc($NDOC);
		$SEEALSO = "\"uid=eveas,o=us.es,dc=us,dc=es\"";
		if (! $ALSO eq "") {
		$SEEALSO = "\"uid=".$ALSO.",o=us.es,dc=us,dc=es\"";
		}
		$UID = $UID."-ext";
       		$fecha = $FECHA_osuna;
		$cuerpo = ",$VINCULACION,$SEEALSO,$MAIL,$UID,\"uid=$UID,o=us.es,dc=us,dc=es\"";		
	}
	elsif ($colectivo eq "UNIVERSIDADES")
	{
		($NDOC,$NOM,$AP1,$PASS,$FECHA_VALIDEZ,$MAIL) = @lista;
		$TDOC = "P";
		$AP2 = $NDOC;
       		$fecha = $FECHA_VALIDEZ;
		$UID=lc($NDOC);
		$VINCULACION = "UNIVERSIDAD".": ".uc($NOM);
		$RES="carlosjavier";
		$SEEALSO = "\"uid=$RES,o=us.es,dc=us,dc=es\"";
		$UID = $UID;  # YA INCLUYEN . "-ext";

		$cuerpo = ",$VINCULACION,$SEEALSO,$MAIL,$UID,\"uid=$UID,o=us.es,dc=us,dc=es\"";		
	}
	elsif ($colectivo eq "IBIS")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$CLAVE,$FECHA_IBIS,$UID,$MAIL) = @lista;
		$VINCULACION = "IBIS ".uc($TDOC).":".$NDOC;
		$NDOC = $colectivo.$NDOC;
		$TDOC = "P";
		$SEEALSO = "\"uid=fcazorla-ibis,o=us.es,dc=us,dc=es\"";
#		$UID = $UID . "-ibis";
		$UID = $UID;
       		$fecha = $FECHA_IBIS;
		$PASS = $CLAVE;
	
		$cuerpo = ",$VINCULACION,$SEEALSO,$UID,\"uid=$UID,o=us.es,dc=us,dc=es\",$MAIL";		
	}
	elsif ($colectivo eq "INSTITUCIONAL")
	{
		($NDOC,$NOM,$AP1,$AP2,$FECHA,$RESPONSABLE,$VINCULACION,$MAIL) = @lista;
		$TDOC = "P";
		$UID = lc($NDOC);
		$NDOC = uc($NDOC);
      		$fecha = $FECHA;
		$SEEALSO = "\"uid=".$RESPONSABLE.",o=us.es,dc=us,dc=es\"";
 		$PASS = "EcDc048H";
	
		$cuerpo = ",$SEEALSO,$VINCULACION,$UID,\"uid=$UID,o=us.es,dc=us,dc=es\",$MAIL";		
	}
	
	elsif ($colectivo eq "PROFESORSECUNDARIA" || $colectivo eq "PAU" || $colectivo eq "MAES")
	{

	        ($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS,$MAIL,$fecha) = @lista;
		$VINCULACION=$colectivo;
  		$cuerpo = ",$MAIL,$VINCULACION";
                if ($colectivo eq  "MAES")
                 {
			$fecha = "2018/09/30";
                 }
	}
	elsif ($colectivo eq "ADMCS" || $colectivo eq "AACCSS")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS,$MAIL,$fecha) = @lista;
  		$cuerpo = ",$MAIL";		
	}
	elsif ($colectivo eq "ALUMNOSECUNDARIA")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS) = @lista;
		
		$PASS = "$PASS";
		$VINCULACION = $anio;
		$fecha = $anio."/11/20";
		$cuerpo = "";
                $cuerpo = ",$VINCULACION";		
	}
	elsif ($colectivo eq "EXALUMNO")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS) = @lista;
		
		$PASS = "EcDc048H";
		$cuerpo = "";		
	}
        elsif ($colectivo eq "MASTER" || $colectivo eq "GRADOS" || $colectivo eq "AulaExperiencia")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS) = @lista;
		$PASS = "us".$PASS;
		$cuerpo = "";	
		$VINCULACION = $colectivo." ".$anio;
                $cuerpo = ",$VINCULACION";	
	}
	elsif ($colectivo eq "ERASMUS")
	{
		($TDOC,$NDOC,$NOM,$AP1,$AP2,$PASS) = @lista;
		$PASS = $PASS;
		$cuerpo = "";
		$VINCULACION = "ERASMUS ".$anio;
                $cuerpo = ",$VINCULACION";

				
	}
	elsif ($colectivo eq "DOCTORADO")
	{
	($NDOC,$NOM,$AP1,$AP2,$PASS,$VINCULACION,$RESPONSABLE) = @lista;
	$TDOC = "P";
	$UID = $NDOC;
	$VINCULACION = "PROGRAMA DOCTORADO ".uc($AP2);
	$SEEALSO = "\"uid=${RESPONSABLE},o=us.es,dc=us,dc=es\"";
	$cuerpo = ",$VINCULACION,$SEEALSO,$UID,\"uid=$UID,o=us.es,dc=us,dc=es\"";
	}

	if ($TDOC ne 'P' and length($NDOC) < 8) 
	{
	   $ceros = 8 - length($NDOC);
	   $NDOC = "0"x$ceros . $NDOC;
        }
# Convertir a mayúsculas los datos ID de usuario
	$TDOC = uc($TDOC);

	if ($colectivo eq "PDIEXTERNO")
	{
	 print "$TDOC:$NDOC,$TDOC,$NDOC,".uc($NOM).",".uc($AP1).",".uc($AP2).",|Merge|$ROL,$PASS,$PASS,"."true,NoEspecificado,$fecha,$fecha,CreateOrUpdate".$cuerpo;
	}
	else
	{
         
	    print  "$TDOC:$NDOC,$TDOC,$NDOC,".uc($NOM).",".uc($AP1).",".uc($AP2).",|Merge|$ROL,$PASS,$PASS,"."true,NoEspecificado,$fecha,$fecha,CreateOrUpdate".$cuerpo;
	}
  

    print "\n";
}


sub ayuda {
	print <<EOF;

Fecha y hora actual $fecha_hora 

Fecha POR DEFECTO $fecha, Sintaxis:

 $0 [-pre] [-colectivo c] [-entrada e] [-fecha f]

Opciones:
	-pre, -p		Indica si trabajamos en preproducción.

	-coletivo c, -c c 	Define el grupo para la Bulkaction. Dato requerido.
				[A6, GIE, CSIC, FIUS, IBIS, PROFESORSECUNDARIA,EXALUMNO, ALUMNOSECUNDARIA, ADMCS, UNIVERSIDADES, MASTER, ERASMUS, PDIEXTERNO, DOCTORADO, INSTITUCIONAL] 
  			
	-entrada e, -e e 	Nombre del fichero de entrada.
  				por defecto "ficheroatratar.csv" .

	-fecha f, -f f 		Fecha de validez. Formato AAAA/MM/DD,
				por defecto 1 año  y 28 de Noviembre,  desde hoy $fecha_sys

EOF
}
