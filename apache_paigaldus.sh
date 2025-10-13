#!/bin/bash
# ---------------------------------------------
# Fail: apache_paigaldus.sh
# Autor: <sinu_nimi>
# Kirjeldus: Kontrollib, kas Apache2 teenus on paigaldatud.
# Kui ei ole, paigaldab selle automaatselt.
# Kui on, kuvab info ja teenuse staatuse.
# ---------------------------------------------

# Teenuse nimi (vajadusel saab muuta)
TEENUS="apache2"

echo "Kontrollin, kas teenus '$TEENUS' on paigaldatud..."

# Kontrollime, kas Apache on paigaldatud (kas dpkg-query väljundis on 'ok installed')
OLEMAS=$(dpkg-query -W -f='${Status}' $TEENUS 2>/dev/null | grep -c "ok installed")

if [ "$OLEMAS" -eq 0 ]; then
    echo "Teenust '$TEENUS' ei ole paigaldatud."
    echo "Paigaldan teenuse..."
    apt update
    apt install -y $TEENUS

    # Kontrollime, kas paigaldus õnnestus
    if [ $? -eq 0 ]; then
        echo "Teenuse '$TEENUS' paigaldus õnnestus!"
        echo "Teenuse olek:"
        systemctl status $TEENUS --no-pager
    else
        echo "Viga: teenuse '$TEENUS' paigaldamine ebaõnnestus."
        exit 1
    fi
else
    echo "Teenuse '$TEENUS' on juba paigaldatud."
    echo "Teenuse olek:"
    systemctl status $TEENUS --no-pager
fi

echo "---------------------------------------------"
echo "Skript lõpetas töö."
