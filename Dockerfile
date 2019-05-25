FROM ubuntu:bionic

RUN apt-get update && apt-get -y install wget firefox locales libgl1-mesa-glx libqt5x11extras5 libgtk2.0.0 libnss3 && \
    wget https://info.eidentita.cz/Download/eObcanka.deb && \
    apt-get -y install ./eObcanka.deb && \
    firefox -headless -CreateProfile docker && \
    /bin/echo "user_pref(\"browser.tabs.remote.autostart\", false);" > /root/.mozilla/firefox/$(ls /root/.mozilla/firefox | grep docker)/user.js && \
    /bin/echo -e '#!/bin/bash\n/opt/eObcanka/Identifikace/eopauthapp $1' > /opt/eObcanka/Identifikace/eopauthapp.sh && \
    /bin/echo -e '#!/bin/bash\npcscd\nexec "$@"' > /root/entrypoint.sh && \
    chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["/usr/bin/firefox", "-P", "docker", "https://obcan.portal.gov.cz/prihlaseni"]

