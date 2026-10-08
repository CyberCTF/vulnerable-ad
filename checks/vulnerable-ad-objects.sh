#!/bin/sh
# vulnerable-AD ran on dc01: its groups and its Kerberoastable service account are in cs.org.
# An LDAP search as the provisioning account (a member of the domain after promotion).
set -eu
base="DC=cs,DC=org"
q() { curl -sS --max-time 20 -u 'CS\vagrant:vagrant' "ldap://dc01/$base?$1?sub?$2"; }
q cn "(cn=IT%20Admins)" | grep -q "CN=IT Admins"
q servicePrincipalName "(cn=mssql_svc)" | grep -qi "mssql_svc/mssqlserver.cs.org"
echo "vulnerable-AD groups and service accounts are in cs.org"
