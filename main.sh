#!/bin/bash

# Kübra Fison
# 2420191055
# https://www.btkakademi.gov.tr/portal/certificates/validate?certificateId=bx1hL8d2oG
# https://www.btkakademi.gov.tr/portal/certificates/validate?certificateId=pKmhqqO7eZ
# https://credsverse.com/credentials/1007ea62-4dac-44d2-a69c-a256059b2dcf

# 1. Log dosyası oluşturma ve ISO formatında tarih/saat ekleme
LOG_FILE="report.log"
echo "$(date --iso-8601=seconds)" > "$LOG_FILE"

echo "=== DONANIM BILGILERI ===" >> "$LOG_FILE"

# 2. Windows donanım bilgilerini toplama
echo "[Islemci Bilgisi]" >> "$LOG_FILE"
wmic cpu get Name, NumberOfCores, MaxClockSpeed >> "$LOG_FILE" 2>&1

echo -e "\n[RAM Bilgisi]" >> "$LOG_FILE"
wmic memorychip get Capacity, Speed >> "$LOG_FILE" 2>&1

echo -e "\n[Anakart Bilgisi]" >> "$LOG_FILE"
wmic baseboard get Product, Manufacturer >> "$LOG_FILE" 2>&1

echo -e "\n[UUID Disk Bilgisi]" >> "$LOG_FILE"
wmic diskdrive get DeviceID, SerialNumber >> "$LOG_FILE" 2>&1

echo -e "\n[MAC Adresi Bilgisi]" >> "$LOG_FILE"
getmac >> "$LOG_FILE" 2>&1

# 3. Kullanıcıdan parola alma
echo "Lutfen parolayi giriniz (MYO+202):"
read -s PAROLA

# 4. gpg ile AES256 şifreleme (Batch modunda arka planda)
echo "$PAROLA" | gpg --batch --yes --passphrase-fd 0 --cipher-algo AES256 -c "$LOG_FILE"

# 5. Orijinal dosyayı temizleme
if [ -f "report.log.gpg" ]; then
    rm -f "$LOG_FILE"
    echo "Islem basarili! report.log.gpg olusturuldu."
else
    echo "Hata: Sifreleme basarisiz!"
    exit 1
fi
