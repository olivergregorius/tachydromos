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
instances.<br>
All LDAP servers that support the LDAP protocol are supported.<br>
The following database engines are supported:

- PostgreSQL

## Deploying the Helm chart

Adjust the `values.yaml` according to your needs and deploy the Helm chart using the following command:

`helm upgrade --install tachydromos charts/tachydromos`

## Setting up the LDAP schema (only external LDAP server)

To enable all features, e.g. quota handling, the Tachydromos LDAP schema must be added to an externally managed LDAP server. You can find the relevant ldif-file
in the `assets/ldap` directory.

## Setting up the database (only external database server)

If you are about to use an externally managed database server there is not much to prepare. Just create an empty database and a user which is permitted to
create new schemas and tables (write access).

# More documentation is about to come
