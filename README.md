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
DN defined as `<ldap.domainSearchBase>,<ldap.rootDn>`. The default value is `ou=domains,dc=tachydromos,dc=org`. Set the `ou` attribute to the domain name. For
example if the domain `example.org` should be handled, the following entry must be added:

```
dn: ou=example.org,ou=domains,dc=tachydromos,dc=org
objectClass: organizationalUnit
objectClass: top
ou: example.org
```

### Managing users

Each user must be added to the LDAP tree. To add a new user add an `inetOrgPerson` entry with an auxiliary `mailAccount` under the DN defined as
`<ldap.userSearchBase>.<ldap.rootDn>`. The default value is `ou=users,dc=tachydromos,dc=org`. Set the `mail` attribute to the mail address of the user. Set the
remaining attributes to suit the needs of the user. Example:

```
dn: mail=testuser@example.org,ou=users,dc=tachydromos,dc=org
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

# More documentation is about to come
