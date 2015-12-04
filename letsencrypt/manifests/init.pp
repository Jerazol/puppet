class letsencrypt (
  $sites = {},
) {
  user {'letsencrypt':
    ensure      => present,
    managehome  => true,
    home        => '/var/lib/letsencrypt',
    shell       => '/bin/bash'
  }

  file {
    '/var/lib/letsencrypt/keys/':
      owner   => 'letsencrypt',
      ensure  => directory,
      mode    => '0750',
      require => User['letsencrypt'];
    '/var/www/challenges/':
      owner   => 'letsencrypt',
      ensure  => directory,
      mode    => '0755',
      require => User['letsencrypt'];
    '/var/lib/letsencrypt/csrs/':
      owner   => 'letsencrypt',
      ensure  => directory,
      mode    => '0750',
      require => User['letsencrypt'];
    '/var/lib/letsencrypt/crts/':
      owner   => 'letsencrypt',
      ensure  => directory,
      mode    => '0750',
      require => User['letsencrypt'];
  }

  exec { 'account_key':
    command => '/usr/bin/openssl genrsa 4096 > /var/lib/letsencrypt/keys/account.key',
    creates => '/var/lib/letsencrypt/keys/account.key',
    user    => 'letsencrypt',
    require => User['letsencrypt'],
  }

  exec { 'wget_intermediate_pem':
    command => '/usr/bin/wget -O - https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > /var/lib/letsencrypt/crts/intermediate.pem',
    user    => 'letsencrypt',
    require => File['/var/lib/letsencrypt/crts/'],
    creates => '/var/lib/letsencrypt/crts/intermediate.pem',
  }

  create_resources('letsencrypt::certificate', $sites)
}
