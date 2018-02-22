#!/bin/bash
####################################################################################
# Autor: Antonio González
# Proposito del script: 
# Crear alias genéricos para poder usarlos en los scripts
#
# Última actualización: 2018/01/11
## Ultimo cambio realizado:
#  agregada alias cls
# 
# Como usarlo
# poner el alias en lugar de la orden
####################################################################################
alias cls=clear
alias ping='ping -c5'
alias nota_globo='notify-send '
alias keybsp='setxkbmap es'
alias fechaeuro=`date  -u`
alias fechaansi='date -I'
alias fecha='date  "+%d-%m-%Y"'
alias hora='date  "+%r"'
alias ultima-edit-file="date -r $1"
