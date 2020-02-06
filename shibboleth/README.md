# Shibboleth SP

These are the Anisble Playbooks used to configure a LAPPS Grid Shibboleth service provider.

## Prerequistites

A suitable server must already be available.  This playbook does not include provisioning a Jetstream instance.

## Setup

Modify the `hosts.shib` file to include the IP address of the server in the *[shibboleth]* group.  The user name and location of the key file must also be updated.

```ini 
[shibboleth]
149.165.157.93 ansible_ssh_private_key_file=~/.ssh/lappsgrid-shared-key.pem ansible_ssh_user=root
```  

## Playbooks

#### shibboleth.yml

This is the main playbook that configures a Shibboleth Service Provider using an InCommon `MetadataProvider`.

**NOTE** This playbook currently configures the SP to use Brandeis as the IdP and `MetadataProvider` during testing and development.  The InCommon configuration is present, but has been commented out for now.

#### shibboleth-vassar.yml

A parameterized version of the *shibboleth.yml* playbook that configures an SP to use Vassar for the IdP and `MetadataProvider`.

#### restart-servers.yml

Restarts the *shibd* and *apache2* servers.

#### upload-shibboleth2.yml

Copies the `files/shibboleth2.xml` configuration file to `/etc/shibboleth` on the SP.

