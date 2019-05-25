# eop-docker

Web [portál občana](https://obcan.portal.gov.cz) umožňuje přihlášení pomocí nových občanských průkazů s čipem. Bohužel obslužná aplikace pro Linux je vydaná pouze jako `deb` balíček pro Ubuntu.

Tento repozitář obsahuje návod k vytvoření Docker image založeném na Ubuntu, který obsahuje nainstalovaný Firefox a obslužnou aplikaci eObčanka. Kvůli nutnosti přístupu k displayi a čtečce karet je nutné dát běžícímu kontejneru rozsáhlá oprávnění.

Testovaný setup:
- Fedora 30
- Dell Latitude E7470
- Integrovaná čtečka karet


## Build

Docker image je vytvořen pomocí souboru `Dockerfile`.

```{.sh}
$ sudo docker-compose build
```

Provádí se následující kroky:
- stažení a nainstalování závislotí (systémové balíčky)
- stažení a nainstalování `eObcanka.deb` z webu [eidentita.cz](https://info.eidentita.cz/Download)
- vytvoření nového profilu pro Firefox s nastavením volby `browser.tabs.remote.autostart` na `false` (opraví padání prohlížeče)
- úprava spouštěcího skriptu `/opt/eObcanka/Identifikace/eopauthapp.sh` tak, aby nenačítal nastavení proxy z `gsettings`
- entrypoint spustí `pcscd` démona pro komunikaci s čtečkou karet
- command spustí Firefox s vlastním profilem a otevře spránku pro přihlášení k portálu občana

## Příprava hosta

Před spuštěním je potřeba připravit hostitelský počítač, například takto:

```{.sh}
$ sudo ./prepare-host.sh
```

Tento skript provede následující akce:
- spustí Docker daemon
- povolí přístup k obrazovce
- přepne SELinux do `permissive` módu - **!! po ukončení práce přepněte opět do `enforcing` módu !!**
- zastaví démona `pcscd`

## Spuštění

Vlastní spuštění provedeme přes `docker-compose`, kde jsou nastaveny všechny proměnné prostředí a připojené složky tak, aby vše fungovalo.

```{.sh}
$ sudo docker-compose up
```

Spustí se Firefox s otevřenou přihlašovací stránkou k portálu občana.

### Identifikace a Správce karty

Aplikace pro diagnostiku identifikace a správce karty lze spustit takto:

```{.sh}
$ sudo docker-compose run eop /opt/eObcanka/Identifikace/eopauthapp
$ sudo docker-compose run eop /opt/eObcanka/SpravceKarty/eopcardman --no-sandbox
```

