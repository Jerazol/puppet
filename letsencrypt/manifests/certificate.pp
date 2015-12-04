define letsencrypt::certificate (
  $domain,
  $domain_alias   = ''
){
  exec { "${domain}_key":
    command => "/usr/bin/openssl genrsa 4096 > /var/lib/letsencrypt/keys/$domain.key",
    creates => "/var/lib/letsencrypt/keys/$domain.key",
    user    => 'letsencrypt',
    require => File['/var/lib/letsencrypt/keys/'],
  }


  if $domain_alias == '' {
    #for a single domain
    exec { "${domain}_csr":
      command => "/usr/bin/openssl req -new -sha256 -key /var/lib/letsencrypt/keys/$domain.key -subj \"/CN=$domain\" > /var/lib/letsencrypt/csrs/$domain.csr",
      creates => "/var/lib/letsencrypt/csrs/$domain.csr",
      user    => 'letsencrypt',
      require => File['/var/lib/letsencrypt/csrs/'],
    }
  } else {
    #for multiple domains (use this one if you want both www.yoursite.com and yoursite.com)
    exec { "${domain}_csr":
      command => "/usr/bin/openssl req -new -sha256 -key /var/lib/letsencrypt/keys/$domain.key -subj \"/\" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf \"[SAN]\\nsubjectAltName=DNS:$domain,DNS:$domain_alias\")) > /var/lib/letsencrypt/csrs/$domain.csr",
      creates => "/var/lib/letsencrypt/csrs/$domain.csr",
      user    => 'letsencrypt',
      require => File['/var/lib/letsencrypt/csrs/'],
    }
  }

  exec { "${domain}_crt":
    command => "/usr/bin/python /usr/local/bin/acme_tiny.py --account-key /var/lib/letsencrypt/keys/account.key --csr /var/lib/letsencrypt/csrs/$domain.csr --acme-dir /var/www/challenges/ > /var/lib/letsencrypt/crts/$domain.crt",
    creates => "/var/lib/letsencrypt/crts/$domain.crt",
    user    => 'letsencrypt',
    require => Exec["${domain}_csr"],
  }

  exec { "${domain}_pem":
    command => "/bin/cat /var/lib/letsencrypt/crts/$domain.crt /var/lib/letsencrypt/crts/intermediate.pem > /var/lib/letsencrypt/crts/$domain.pem",
    user    => 'letsencrypt',
    require => [Exec["${domain}_crt"],Exec['wget_intermediate_pem']],
    creates => "/var/lib/letsencrypt/crts/$domain.pem",
  }

}
