#!/usr/bin/perl
#
#Â Extractor de datos de LDAP
#Â  v2008.12.01-1
#
# Opciones:
#
#  -atr atributo: recoge el atributo indicado
#  -dn / -nodn: imprime o no el DN delante de la entrada (por defecto: no)
#  -base: base para la bÃºsqueda en LDAP (por defecto: dc=us,dc=es)
#  -filtro: filtro para la bÃºsqueda en LDAP (por defecto: uid=*)
#  -sep: separador para el caso de que haya varios atributos (por defecto:
#        |)

use Net::LDAP;
use IO::Handle ();
use Getopt::Long;

# Comienzo
$| = 1;
STDOUT->autoflush(1);
$ponerdn = '1'; # Por defecto
$base = 'dc=us,dc=es';
$filtro = 'uid=*';
$sep = '|';


# Ayuda
if ($ARGV[0] eq '--help' or
	$ARGV[0] eq '-h') {
	&ayuda;
	exit 0;
}


# Parámetros de línea de Órdenes
if (! GetOptions("dn!"=>\$ponerdn, # sÃ­ o no
            "atr=s" => \@atr, # varias cadenas
            "base=s" => \$base, # cadena
	   		"filtro=s" => \$filtro, # cadena
            "sep=s" => \$sep, # cadena 
          )) {
	  &ayuda;
	  exit 1;
}

if ($ARGV[0] ne "") {
	print STDERR "Opciones desconocidas:\n";
	foreach (@ARGV) {
		print STDERR " $_\n";
	}
	&ayuda();
	exit 1;
}

#if (!defined (@atr) or length(@atr) == 0) {
 if (!@atr or length(@atr) == 0) {
	print STDERR "Sin atributos para consultar\n";
	&ayuda();
	exit 1;
}

$ldap = Net::LDAP->new(
#		'ldap.us.es',
# cambiado para acceso desde intranet con VPN
		'192.168.4.99',
		version => 3,
		debug => 0) or die "$@";

$mesg = $ldap->bind('cn=directory manager',
                      password => 'pqeecdsm'
		  );


$mesg = $ldap->search( # perform a search
		base   => $base,
		scope => "sub",
		filter => $filtro,
		callback => \&muestraReg
	      );

$mesg->code && die $mesg->error;


$mesg = $ldap->unbind;   # take down session


sub muestraReg {
	my ($mesg, $entry) = @_;

	if ( !defined($entry) ) {
#		if ($mesg->count == 0) {
#			print STDERR "Sin resultados\n";
#		}
		return;
	} else {

		my @linea = ();
		if ($ponerdn) {
			$linea[0] = $entry->dn;
		}
		foreach (@atr) {
			if ($entry->exists($_)) {
				my $linea;
				# Multivaluados y simples
				@valores = $entry->get_value($_);
				$nuevocampo = join(",", @valores);
				push(@linea, $nuevocampo);
			} else {
				# Que se vea en blanco
				push(@linea, '');
			}
		}

		# ImpresiÃ³n de la lÃ­nea
		print join($sep, @linea), "\n";


		# Liberamos memoria
		$mesg->pop_entry();
	}
}


sub ayuda {
	print <<EOF;
Sintaxis:

 ./extrae.pl [-nodn] [-base b] [-filtro f] [-sep s] 
 		-atr atr1 [-atr atr2] [-atr ...]

Opciones:
  -nodn			no muestra el DN de cada entrada. 
  			[mostrado por defecto]
  -base b, -b b		utiliza como base de la consulta la especificada
  -filtro f, -f f	el filtro f serÃ¡ usado en la bÃºsqueda
  -sep s, -s s		usar el carÃ¡cter/cadena 's' para separar los
			distintos atributos especificados de cada entrada
			["|" por defecto]
  -atr a, -a a		imprimir en la salida el atributo a 

EOF
}
