# Tachydromos - Mail Suite on Kubernetes

This Helm chart bundles a complete mail suite containing all required components for a mail system for deployment on a Kubernetes cluster. The included
components are:

| Component       | Role                                                       |
|-----------------|------------------------------------------------------------|
| Postfix         | MSA/MTA                                                    |
| Dovecot         | MDA                                                        |
| Rspamd          | Spam filter                                                |
| SOGo            | Webmail                                                    |
| LDAP server     | Domain- and user-management, authentication, authorization |
| Database server | Persistence of user data (SOGo)                            |

The LDAP server (OpenLDAP) and database server (PostgreSQL) can be deployed as part of this Helm chart. Alternatively you are able to use already running
instances.

All LDAP servers that support the LDAP protocol are supported.

The following database engines are supported:

- PostgreSQL

## What does "Tachydromos" mean?

"Tachydromos", or "ταχυδρόμος", is greek for "mailman" which suits very good for a mail suite on "Kubernetes", or "κυβερνήτης", which in fact is also a greek
word translated to "captain" in english.

## Deploying the Helm chart

### Add repository

`helm repo add olivergregorius https://olivergregorius.github.io/helm-charts`

### Adjust values.yaml

Copy the default `values.yaml` file from `charts/tachydromos` to a location of your choice and adjust the values to suit your needs.

### Deploy application

`helm upgrade --install --values values.yaml my-tachydromos olivergregorius/tachydromos`

where `--values values.yaml` should point to the adjusted Helm values file created in the previous step and `my-tachydromos` corresponds to the release name.
Feel free to change it. Furthermore, additional flags can be added to the `helm install` command.

## LDAP configuration

### Using an external LDAP server

Instead of using the embedded OpenLDAP server you can use an external LDAP server. To disable the embedded OpenLDAP server simply apply the value

```yaml
ldap:
  embedded:
    enabled: false
```

#### Setting up the LDAP schema

To enable all features, e.g. quota handling, the Tachydromos LDAP schema must be added to an external LDAP server. You can find the relevant ldif-file in the
`assets/ldap` directory.

### Managing domains

Tachydromos requires all domains for which mails should be handled to be listed in the LDAP tree. For each domain add a new `organizationalUnit` entry under the
DN defined as `<ldap.domainSearchBase>,<ldap.rootDn>`. The default value is `ou=domains,dc=tachydromos,dc=local`. Set the `ou` attribute to the domain name. For
example if the domain `example.org` should be handled, the following entry must be added:

```
dn: ou=example.org,ou=domains,dc=tachydromos,dc=local
objectClass: organizationalUnit
objectClass: top
ou: example.org
```

### Managing users

Each user must be added to the LDAP tree. To add a new user add an `inetOrgPerson` entry with an auxiliary `mailAccount` under the DN defined as
`<ldap.userSearchBase>.<ldap.rootDn>`. The default value is `ou=users,dc=tachydromos,dc=local`. Set the `mail` attribute to the mail address of the user. Set the
remaining attributes to suit the needs of the user. Example:

```
dn: mail=testuser@example.org,ou=users,dc=tachydromos,dc=local
objectClass: inetOrgPerson
objectClass: mailAccount
objectClass: organizationalPerson
objectClass: person
objectClass: top
cn: Test User
sn: User
givenName: Test
userPassword: <encrypted>
mail: testuser@example.org
mailAlias: anotheruser@example.org
mailActive: TRUE
mailQuotaMb: 2048
mailSendOnly: FALSE
mailSuperUser: FALSE
```

Attribute description:

| Attribute     | Description                                                            | Remarks                                                                                                                                                                             |
|---------------|------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cn            | Display name of the user in Webmail                                    |                                                                                                                                                                                     |
| sn            | Surname of the user                                                    |                                                                                                                                                                                     |
| givenName     | Name of the user                                                       |                                                                                                                                                                                     |
| userPassword  | Password for Webmail login                                             |                                                                                                                                                                                     |
| mail          | Primary mail address of the user                                       |                                                                                                                                                                                     |
| mailAlias     | Mail alias address                                                     | This attribute can be added multiple times. Mails will be received for each mailAlias. The user can use any of his mailAlias addresses as from-address in the Webmail.              |
| mailActive    | True if the mail account is active for the user, false otherwise       | If the mail account is not active, no mails are received for the addresses of the user and he is not able to login to Webmail.                                                      |
| mailQuotaMb   | Mailbox quota in MB                                                    |                                                                                                                                                                                     |
| mailSendOnly  | True if only sending of mails is allowed for the user, false otherwise | If enabled the user will not receive any mails. Useful for a no-reply address.                                                                                                      |
| mailSuperUser | True if the user can use any sender mail address, false otherwise      | If enabled the user can use any mail address as from-address, even if it is not contained in his `mail` attribute or any of his `mailAlias` attributes. Useful for technical users. |

**NOTE:** Ensure that for each added user the corresponding domain is added to the managed domains as well (see [Managing domains](#managing-domains)).

## Setting up the database (only external database server)

If you are about to use an externally managed database server there is not much to prepare. Just create an empty database and a user which is permitted to
create new schemas and tables (write access).

## Publishing the SMTP server

In order to receive mails the SMTP server (Postfix) must be published to the outside world. There are different approaches to achieve this. By default, the
server is published using [nodeports](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport). Thus, on each of the cluster's nodes a
port will be opened to listen for SMTP traffic. As SMTP traffic always flows on port 25 a TCP reverse proxy, e.g. HAProxy, is needed for port translation.
Tachydromos also provides the option to use the [HAProxy PROXY-protocol](https://www.haproxy.com/blog/use-the-proxy-protocol-to-preserve-a-clients-ip-address)
to preserve the client's IP address required for spam checks and sender validation.

### STARTTLS SMTP encryption

The SMTP server will use the same TLS server certificates as the webmail does. Thus, encrypted SMTP traffic is enabled by default.

## Accessing the Rspamd webinterface

The Rspamd webinterface is available under the configured ingress hostname.

## Accessing Webmail

[SOGo](https://www.sogo.nu) is used as webmail component for Tachydromos. It provides many groupware features such as mail-, contact- and calendar-management.
Furthermore, it offers an in place solution for connecting via the Microsoft Exchange ActiveSync protocol - an easy way to synchronize mails, contacts and
events with all of your devices.
The webmail is published under the URL set as `hostname` in the Helm values.

## Planned features

Although Tachydromos is a useful suite of some useful components, not all possible features have been implemented, yet. Some planned features are:

- Separate URLs for webmail and SMTP
- Webinterface for management of domains and users
- Antivirus
- and many more
