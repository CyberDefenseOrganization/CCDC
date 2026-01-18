#!/bin/bash

echo "Adding in the new Auditd rules file, look up how to use this or ask tyler :)."
sudo rm /etc/audit/auditd/rules.d
sudo mv auditd /etc/audit/auditd/rules.d
sudo systemctl restart auditd
sudo auditctl -R /etc/audit/auditd/rules.d

Echo "Listing to see if the new rules took effect"
sudo auditctl -l
