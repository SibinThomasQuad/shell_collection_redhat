#!/bin/bash

# Install Apache and ModSecurity
sudo dnf install -y httpd mod_security

# Enable ModSecurity
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/httpd/conf.d/mod_security.conf

# Create ModSecurity configuration file
sudo tee /etc/httpd/modsecurity.d/modsecurity.conf <<EOF
SecRuleEngine On
SecAuditLog /var/log/httpd/modsec_audit.log
SecAuditLogType Serial
SecAuditLogStorageDir /var/log/httpd/audit/
SecDebugLog /var/log/httpd/modsec_debug.log
SecDebugLogLevel 0
SecRequestBodyAccess On
SecResponseBodyAccess On
SecResponseBodyMimeType (null) text/html text/plain text/xml
EOF

# Restart Apache
sudo systemctl restart httpd
