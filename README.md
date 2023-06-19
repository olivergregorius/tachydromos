# tachydromos - Mail Suite on Kubernetes

This Helm chart bundles a complete mail suite containing all required components for a mail system for deployment on a Kubernetes cluster. The included
components are:

| Component             | Role                                                                                                    |
|-----------------------|---------------------------------------------------------------------------------------------------------|
| Postfix               | MSA/MTA                                                                                                 |
| Dovecot               | MDA                                                                                                     |
| Rspamd                | Spam filter                                                                                             |
| SOGo                  | Webmail                                                                                                 |
| OpenLDAP (optional)   | Domain- and user-management, authentication, authorization                                              |
| PostgreSQL (optional) | Database for user data, domain- and user-management, authentication/authorization (if LDAP is not used) |

OpenLDAP and PostgreSQL are optional components of this suite and can be replaced by already existing instances.<br>
All LDAP servers that support the LDAP protocol are supported.<br>
The following database engines are supported:

- PostgreSQL
