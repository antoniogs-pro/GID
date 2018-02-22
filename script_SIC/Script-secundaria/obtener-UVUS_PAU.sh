cat alta.ba |sed -e 1d | cut -d, -f 1 | bash /home/sic/SIC/script_SIC/LDAP_obtener_UVUS_desde_tndoc.sh| sed s/ /_/g | tee alta+UVUS.csv
