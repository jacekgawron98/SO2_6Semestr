#!/bin/bash -eu

#znajdź w pliku access_log zapytania, które mają frazę "denied" w linku
cat access_log | grep ".denied." 
#znajdź w pliku access_log zapytania typu POST
cat access_log | grep "\"POST"
#znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
cat access_log | grep "^64\.242\.88\.10 "
#znajdź w pliku access_log zapytania nie wysłane z adresu IP tylko z FQDN ---
cat access_log | grep -vE "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
#znajdź w pliku access_log unikalne zapytania typu DELETE
cat access_log | grep "\"DELETE" | sort -u
#znajdź uniklanych 10 adresów IP w access_log
cat access_log | awk -F'-' '{print $1}' | grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort -u | head -n 10


#Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą. Wyniki zapisz na standardowe wyjście błędów
cat yolo.csv | awk -F, '{if ($1 % 2 == 1) print }' 1>&2
#Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 lub $9.99
cat yolo.csv | grep '$2\.99[A-Z]\|$5\.99[A-Z]\|$9\.99[A-Z]' | awk -F, '{print $2,$3}' 1>&2
#Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim oktecie ma po jednej cyfrze. Wyniki zapisz na standardowe wyjście błędów
cat yolo.csv | awk -F, '{print $6}' | grep -E "^[0-9]\.[0-9]\.[0-9]{1,3}\.[0-9]{1,3}" 1>&2

#We wszystkich plikach w katalogu 'groovies' zamień $HEADERS$ na /temat/
#jeśli chcemy faktycznie zamienić
sed -i 's|\$HEADER\$|/temat/|g' groovies/*
#jeśli tylko wypisać
cat groovies/* | sed 's|\$HEADER\$|/temat/|g'
#We wszystkich plikach w katalogu 'groovies' po każdej linijce 'class' dodać 'String marker = '/!@$%/"
#jeśli chcemy faktycznie zamienić
sed -i "/class */a String marker=\'\!\/@$%/\"" groovies/*
#jeśli tylko wypisać
cat groovies/* | sed "/class */a String marker=\'\!\/@$%/\""
#We wszystkich plikach w katalogu 'groovies' usuń linijki zawierające frazę 'Help docs'
#jeśli chcemy faktycznie zamienić
sed -i "/Help docs:/d" testgr/*
#jeśli tylko wypisać
cat testgr/* | sed "/Help docs:/d"