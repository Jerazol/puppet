Quickly thrown together puppet module based on https://github.com/diafygi/acme-tiny

Usage:

In your manifest:
include letsencrypt

In the relevant hiera file:
    letsencrypt::sites:
      somesite.com:
        domain: 'somesite.com'
      another_site.org:
        domain: 'another_site.org'

You should eventually be able to specify "alias:" as well, but this doesn't quite work yet.
