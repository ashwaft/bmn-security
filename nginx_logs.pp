file { '/etc/nginx/conf.d/logging.conf':
  ensure => present,
  content => "access_log syslog:server=192.168.56.12:514,facility=local0,tag=nginx_client,severity=info;\nerror_log syslog:server=192.168.56.12:514,facility=local0,tag=nginx_client,severity=error;",
}
