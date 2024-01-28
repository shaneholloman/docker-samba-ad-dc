# samba-ad-dc

<-- badge placeholder -->

Samba Active Directory Domain Controller Docker Image - still dev stage - don't use

1. Provision a new domain

    ```sh
    docker run -d --privileged \
      --restart=unless-stopped --network=host \
      -e REALM='SAMDOM.EXAMPLE.COM' \
      -e DOMAIN='SAMDOM' \
      -e ADMIN_PASS='Passw0rd' \
      -e DNS_FORWARDER='1.1.1.1' \
      -v dc1-samba:/usr/local/samba \
      --name dc1 --hostname DC1 shaneholloman/samba-ad-dc
    ```

2. Show logs and run tests

    ```sh
    docker logs dc1 -f
    docker exec dc1 samba-tests
    ```

3. For external access, update the `/etc/resolv.conf` and `/etc/hosts` from your host, replacing `host_ip`

    ```ini
    # /etc/resolv.conf
    search samdom.example.com
    nameserver host_ip

    # /etc/hosts
    127.0.0.1     localhost
    host_ip       DC1.samdom.example.com     DC1
    ```

4. For multiple dc testing (no external access)

    ```sh
    git clone --single-branch https://github.com/shaneholloman/samba-ad-dc
    cd samba-ad-dc
    docker compose build
    docker compose up -d
    docker compose logs -f
    for dc in dc{1,2,3,4}; do docker compose exec $dc samba-tests; done
    ```

TODO:

- [ ] Create vscode devcontainer for portable development of this repo since flipping between os's is a pain
- [ ] [Sysvol replication workaround](https://wiki.samba.org/index.php/Rsync_based_SysVol_replication_workaround)

Links:

- [Setting up](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller)
- [Dependencies](https://wiki.samba.org/index.php/Package_Dependencies_Required_to_Build_Samba)
- [Exposed ports](https://wiki.samba.org/index.php/Samba_AD_DC_Port_Usage)
