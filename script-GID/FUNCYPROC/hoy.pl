#!/usr/bin/perl -w
# ficero: sysdate.pl
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
# Formatos de salida
    my $fecha_hora = "$dias[$diaSemana] $dia de $meses[$mes]  del $anio Hora: $hora_sys";
	$anio += 1;
    my $fecha_val = "$anio\/$mes\/$dia";

#      print "Hoy es: ".$fecha_hora ." \n";
#    print "Fecha validéz: ".$fecha_val ." \n";
    $dia-=1;
    print "$mes/$dia/$anio";
    
  
  
   
# para ejecutar 
#  perl sysdate.pl 
