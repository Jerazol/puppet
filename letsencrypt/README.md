Quickly thrown together puppet module based on https://github.com/diafygi/acme-tiny

Performs steps 1, 2, 4 and partly 5 for you. You still need to configure the webserver yourself

Usage:

In your manifest:
```puppet
include letsencrypt
```

In the relevant hiera file:
```yaml
letsencrypt::sites:
  somesite.com:
    domain: 'somesite.com'
  another_site.org:
    domain: 'another_site.org'
    domain_alias: 'www.another_site.org'
```
