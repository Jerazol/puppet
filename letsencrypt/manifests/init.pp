class letsencrypt {
  user {'letsencrypt':
    ensure      => present,
    managehome  => true,
    home        => '/var/lib/letsencrypt'
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
}
