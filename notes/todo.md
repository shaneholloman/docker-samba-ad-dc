# Todo

Results of running the Samba tests:

- [ ] [samba-tests](../sbin/samba-tests)

```sh
docker exec dc1 samba-tests
```

1. `samba --version`: This command is successful. It shows that the version of Samba is 4.19.4.

2. `testparm`: This command is successful. It loads the Samba configuration file and prints out the service definitions. The output shows that the server role is set to `ROLE_ACTIVE_DIRECTORY_DC`, which means it's configured as an Active Directory Domain Controller.

3. `smbclient -L localhost -U%`: This command is successful. It lists the shares available on the localhost. The output shows `sysvol`, `netlogon`, and `IPC$` shares.

4. `smbclient //localhost/netlogon -UAdministrator -c "ls"`: This command is successful. It connects to the `netlogon` share as the `Administrator` user and lists the files in it.

5. `nslookup "DC1.yoyo.io"`: This command failed. It's trying to resolve the hostname `DC1.yoyo.io` to an IP address, but it can't find it. I need to ensure that the DNS server configured for the container can resolve this hostname.

6. `host -t SRV "_ldap._tcp.yoyo.io"`: This command failed. It's trying to find the SRV record for the LDAP service in the `yoyo.io` domain, but it can't find it. I need to ensure that the DNS server configured for the container has this SRV record.

7. `kinit administrator`: This command failed. It's trying to get a Kerberos ticket for the `Administrator` user, but it can't find the Key Distribution Center (KDC) for the `YOYO.IO` realm. I need to ensure that the Kerberos configuration in the container is correct and that the KDC is reachable.

The failures are likely due to DNS and Kerberos configuration issues. I need to ensure that the DNS server configured for the container can resolve the necessary hostnames and SRV records, and that the Kerberos configuration is correct.

- [ ] Create vscode devcontainer for portable development of this repo since flipping between os's is a pain
- [ ] [Sysvol replication workaround](https://wiki.samba.org/index.php/Rsync_based_SysVol_replication_workaround)
