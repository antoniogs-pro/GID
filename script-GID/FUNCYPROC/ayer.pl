#!/usr/bin/perl -w
# ficero: ayer.pl
use strict;

#ARRAY CON EL NOMBRE DE LOS DIAS EN CASTELLANO
    my @dias   = ('Domingo','Lunes','Martes','Miércoles',
               'Jueves','Viernes','Sábado');

#ARRAY CON EL NOMBRE DE LOS MESES EN CASTELLANO
    my @meses = ('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
                 'Agosto','Septiembre','Octubre','Noviembre','Diciembre');

    my ($segundo,$minuto,$hora,$dia,$mes,$anio,$diaSemana) = (localtime(time))[0,1,2,3,4,5,6];

# Primero tomemos los valores de año asegurando que cuente con cuatro digitos.
	$anio += 1900;
# Segundo tomemos los valores de dia y mes, asegurando que cuenten con
# dos digitos.
	$dia = $dia < 10 ? '0' . $dia : $dia;
	$mes = $mes < 10 ? '0' . $mes : $mes;

# Tercero formateamos la hora y la fecha.
    my $hora_sys = sprintf("%02d:%02d:%02d",$hora,$minuto,$segundo);
    my $fecha_sys = sprintf("%04d/%02d/%02d",$anio,$mes,$dia);

$anio += 1;
$dia-=1;
print "$mes/$dia/$anio $hora_sys WET";
    
