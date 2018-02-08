#/bin/bash -eux

mkdir /var/gs-spring-boot/
cp /tmp/gs-spring-boot.jar /var/gs-spring-boot/
cat <<EOF > /etc/systemd/system/gs-spring-boot.service;
[Unit]
Description=gs-spring-boot
After=syslog.target

[Service]
User=myapp
ExecStart=/var/gs-spring-boot/gs-spring-boot.jar
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF
systemctl enable gs-spring-boot.service
