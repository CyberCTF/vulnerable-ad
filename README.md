# vulnerable-AD

[vulnerable-AD](https://github.com/safebuffer/vulnerable-AD) by WazeHell (now safebuffer): a
PowerShell script that turns a fresh domain controller into a vulnerable Active Directory. This
repository runs it with [Isoloom](https://www.isoloom.com): [`isoloom.yml`](isoloom.yml) describes
the machine, and [`provision/main.yml`](provision/main.yml) builds it from a controller: it
promotes a new forest, `cs.org` (the domain upstream's README uses), then runs upstream's
[`vulnad.ps1`](vulnerable-AD/vulnad.ps1), unchanged, with its documented call
`Invoke-VulnAD -UsersLimit 100 -DomainName cs.org`.

| Machine | Name | Services |
| --- | --- | --- |
| dc01 | domain controller of cs.org (Windows Server 2019) | DNS 53, Kerberos 88, RPC 135, LDAP 389, SMB 445, WinRM 5985 |

The users, groups and ACLs are random on every build. What the script plants: ACL abuse paths
between groups and users, a Kerberoastable service account, AS-REP roastable users, DnsAdmins
members, passwords in descriptions, default and shared passwords, DCSync rights, and SMB client
signing off.

## Run it

```bash
isoloom run vagrant
isoloom test vagrant
```

About 4 GB of memory (3 GB for the domain controller, 1 GB for the controller) and 20 minutes.
The Windows Server 2019 box is an evaluation build downloaded by Vagrant.

One difference from running the script by hand: its last step calls
`Set-SmbClientConfiguration` with an explicit `-Confirm`, which cannot prompt over WinRM; the
playbook applies the same setting without the prompt.

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

MIT, as vulnerable-AD ([LICENSE](LICENSE)). This lab is deliberately vulnerable: keep it isolated.
