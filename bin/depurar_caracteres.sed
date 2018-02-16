# Fichero sed  para eliminar caracteres extraños en un CSV: depurar_caracteres.sed
# probar sed -i 's/^Exec=/# &/'

#################  pre-proceso genérico
# convertir a CSV
# quitar marca BOM en UTF-8
s/^\xEF\xBB\xBF//
#borrar líneas que empiezan con * o #
#^*/d
/^#/d
#borrar líneas en blanco
/^$/d
# no funcionan
#/^.$/d
#/^\n$/d
# Eliminar espacios al principio de línea:
#'s/^ //g'
s/^ *//g 
#  Eliminar todos los espacios que haya al final de cada línea:
#s/ $//g # esto no es lo que parece,  se lo carga todo
s/ *$//g 
#borrar espacio en blanco y tabuladores al principio y al final de la línea
s/^[ \t]*//g
s/[ \t]*$//g
# las dos siguientes  no funcionan se lo cargan todo
#/^\s/s/ //g 
#/\s$/s/ //g
#s/[ ][ ]*/[ ]/g
# eliminar un espacio delante y detrás de comas
s/ ,/,/g
s/, /,/g
/^command/d  #elimina líneas que empiecen con la palabra command
#########################

# eliminar comillas simples sueltas
s/[']//g
# eliminar comillas dobles sueltas
s/\"//g
# eliminar barras
s/\\//g
# s/\///g  error se carga las fechas
# eliminar símbolos
s/\+//g
# eliminar puntos,guiones y barras sueltas en nombres y apellido
# s/,\.,/,,/g # cagada el punto significa un carácter, \. se refiere al símbolo punto pero lo elimina de algunos e-mails que lo llevan
s/,-,/,,/g
s/,_,/,,/g
# la siguiente línea en cuarentena agregado el 16-09-21
s/,\/,/,,/g
# eliminar puntos
#s/\.//g  error se carga los e-mails 

############# Búsqueda y sustitución de caracteres extraños
# sustituir Mª Mº
s/ª/aria /g
#s/º/ero /g
s/[ª]/ /g
s/[º]/ /g
#

# sustituir tildes, dieresis etc
s/[ÁáÄäÃÀÁàÂâÃãÅå]/a/g
s/[ÉéËëÈÈèÊêé]/e/g
s/[ÍíÏïÎîÌìiï]/i/g
s/[ÓóÖöÔôÒòÕõ©]/o/g
s/[ÚúÜüÙùÛû]/u/g
s/[Ÿÿ]/y/g

# sustituir la Ñ
s/[Ñ]/n/g
s/[ñ]/n/g

# sustituir caracteres extraños 
s/[]/s/g
s/[]/n/g
s/[]/n/g

s/[Çç]/c/g
s/[ﾄ]/n/g
s/[Þ]/p/g
s/[ŝ]/s/g
s/[Š]/s/g
s/[žŽ]/z/g
s/[ß]/b/g
s/[아]/o/g
s/[이]/o/g
s/[샤]//g
s/[¸]//g
# la siguiente línea en cuarentena agregado el 16-09-21
s/[–]/"-"/g
# la siguiente línea en cuarentena agregado el 16-09-23
# s/I¿oe/a/g
# la siguiente línea SIEMPRE COMO COMENTARIO solo para recordatorio
#S/I¿œ/FALTA LETRA CON TILDE O LETRA Ñ/G


