#!/bin/bash
# php_paigaldus.sh
# Skript PHP paigaldamiseks Debian 10 süsteemis koos vajalikute abipakettidega
# ja veebiserveri toe seadistamiseks.

# Kontrollime, kas skripti käivitab root
if [ "$(id -u)" -ne 0 ]; then
    echo "Palun käivita skript root-ina (sudo)."
    exit 1
fi

echo "PHP paigaldamise skript alustab..."

# Värskendame pakettide nimekirja
echo "Värskendame pakette..."
apt update

# Paigaldame PHP ja vajalikud moodulid
echo "Paigaldame PHP ja vajalikud paketid..."
apt install -y php libapache2-mod-php php-mysql php-cli php-curl php-gd php-mbstring

# Veebiserveri (Apache2) konfiguratsioon
if dpkg -l | grep -q apache2; then
    echo "Apache veebiserver on paigaldatud."
    echo "Lubame PHP mooduli ja taaskäivitage Apache..."
    a2enmod php
    systemctl restart apache2
else
    echo "Apache2 ei ole paigaldatud. Paigaldame Apache2 koos PHP toe..."
    apt install -y apache2
    a2enmod php
    systemctl restart apache2
fi

# Kontrollime PHP töökindlust
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
echo "PHP testfail loodud: http://localhost/info.php"

echo "PHP paigaldamine ja seadistamine lõpetatud!"

