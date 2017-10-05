# redhat7/services
#
# Implements Center of Internet Security service controls.

class cisecurity::redhat7::services (
  String $auditd_action_mail_acct,
  Enum[
    'email',
    'exec',
    'halt',
    'ignore',
    'rotate',
    'single',
    'suspend',
    'syslog'] $auditd_admin_space_left_action,
  Enum['enabled','disabled'] $auditd_configure_rules,
  Integer $auditd_max_log_file,
  Enum[
    'keep_logs',
    'ignore',
    'rotate',
    'suspend',
    'syslog'] $auditd_max_log_file_action,
  Enum[
    'email',
    'exec',
    'halt',
    'ignore',
    'rotate',
    'single',
    'suspend',
    'syslog'] $auditd_space_left_action,
  Enum['enabled','disabled'] $auditd_configure_boot_auditing,
  Enum['enabled','disabled'] $autofs,
  Enum['enabled','disabled'] $avahi_daemon,
  Enum['enabled','disabled'] $chargen_dgram,
  Enum['enabled','disabled'] $chargen_stream,
  Enum['enabled','disabled'] $configure_auditd,
  Enum['enabled','disabled'] $configure_postfix,
  Enum['enabled','disabled'] $configure_rsyslog,
  Enum['enabled','disabled'] $configure_sshd,
  Enum['enabled','disabled'] $configure_time,
  Enum['enabled','disabled'] $cron,
  Enum['enabled','disabled'] $cups,
  Enum['enabled','disabled'] $daytime_dgram,
  Enum['enabled','disabled'] $daytime_stream,
  Enum['enabled','disabled'] $dhcpd,
  Enum['enabled','disabled'] $discard_dgram,
  Enum['enabled','disabled'] $discard_stream,
  Enum['enabled','disabled'] $dovecot,
  Enum['enabled','disabled'] $echo_dgram,
  Enum['enabled','disabled'] $echo_stream,
  Enum['enabled','disabled'] $httpd,
  Enum['enabled','disabled'] $inetd,
  Enum['enabled','disabled'] $named,
  Enum['enabled','disabled'] $nfs,
  Enum['enabled','disabled'] $ntalk,
  Array[String] $ntp_service_restrictions,
  Enum['enabled','disabled'] $rexec,
  Enum['enabled','disabled'] $rhnsd,
  Enum['enabled','disabled'] $rlogin,
  Enum['enabled','disabled'] $rpcbind,
  Enum['enabled','disabled'] $rsh,
  Enum['enabled','disabled'] $rsyncd,
  String $rsyslog_conf,
  #Array[Hash[String,Integer]] $rsyslog_remote_servers,
  $rsyslog_remote_servers,
  Enum['enabled','disabled'] $slapd,
  Enum['enabled','disabled'] $smb,
  Enum['enabled','disabled'] $snmpd,
  String $sshd_banner_file,
  Integer $sshd_client_alive_count_max,
  Integer $sshd_client_alive_interval,
  Enum['yes','no'] $sshd_hostbased_authentication,
  Enum['yes','no'] $sshd_ignore_rhosts,
  Integer $sshd_login_grace_time,
  Enum[
    'DEBUG',
    'DEBUG1',
    'DEBUG2',
    'DEBUG3',
    'ERROR',
    'FATAL',
    'INFO',
    'QUIET',
    'VERBOSE'] $sshd_log_level,
  Integer $sshd_max_auth_tries,
  Enum['yes','no'] $sshd_permit_empty_passwords,
  Enum['yes','no'] $sshd_permit_root_login,
  Array[String] $sshd_permitted_ciphers,
  Array[String] $sshd_permitted_macs,
  Enum['yes','no'] $sshd_permit_user_environment,
  String $sshd_protocol,
  Enum['yes','no'] $sshd_x11_forwarding,
  Enum['enabled','disabled'] $squid,
  Enum['enabled','disabled'] $telnet,
  Enum['enabled','disabled'] $tftp,
  Enum['enabled','disabled'] $time_dgram,
  Enum['chrony','ntp'] $time_service_provider,
  Array[String] $time_service_servers,
  Enum['enabled','disabled'] $time_stream,
  Enum['enabled','disabled'] $vsftpd,
  Enum['enabled','disabled'] $ypserv,
) {

  if $configure_auditd == 'enabled' {
    class { '::auditd':
      service_ensure          => running,
      service_enable          => true,
      action_mail_acct        => $auditd_action_mail_acct,
      admin_space_left_action => $auditd_admin_space_left_action,
      max_log_file            => $auditd_max_log_file,
      max_log_file_action     => $auditd_max_log_file_action,
      space_left_action       => $auditd_space_left_action,
    }
  }

  if $auditd_configure_boot_auditing == 'enabled' {
    kernel_parameter { 'audit':
      ensure => present,
      value  => '1',
    }
  }

  if $auditd_configure_rules == 'enabled' {
    auditd::rule { '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change': }
    auditd::rule { '-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change': }
    auditd::rule { '-a always,exit -F arch=b64 -S clock_settime -k time-change': }
    auditd::rule { '-a always,exit -F arch=b32 -S clock_settime -k time-change': }
    auditd::rule { '-w /etc/localtime -p wa -k time-change': }
    auditd::rule { '-w /etc/group -p wa -k identity': }
    auditd::rule { '-w /etc/passwd -p wa -k identity': }
    auditd::rule { '-w /etc/gshadow -p wa -k identity': }
    auditd::rule { '-w /etc/shadow -p wa -k identity': }
    auditd::rule { '-w /etc/security/opasswd -p wa -k identity': }
    auditd::rule { '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale': }
    auditd::rule { '-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale': }
    auditd::rule { '-w /etc/issue -p wa -k system-locale': }
    auditd::rule { '-w /etc/issue.net -p wa -k system-locale': }
    auditd::rule { '-w /etc/hosts -p wa -k system-locale': }
    auditd::rule { '-w /etc/sysconfig/network -p wa -k system-locale': }
    auditd::rule { '-w /etc/selinux/ -p wa -k MAC-policy': }
    auditd::rule { '-w /var/log/lastlog -p wa -k logins': }
    auditd::rule { '-w /var/run/faillock/ -p wa -k logins': }
    auditd::rule {'-w /var/run/utmp -p wa -k session': }
    auditd::rule {'-w /var/run/wtmp -p wa -k session': }
    auditd::rule {'-w /var/run/btmp -p wa -k session': }
    auditd::rule {'-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod': }
    auditd::rule {'-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod': }
    auditd::rule {'-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod': }
    auditd::rule {'-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod': }
    auditd::rule {'-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod': }
    auditd::rule {'-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod': }
    auditd::rule { '-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access': }
    auditd::rule { '-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access': }
    auditd::rule { '-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access': }
    auditd::rule { '-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access': }
    auditd::rule { '-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts': }
    auditd::rule { '-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts': }
    auditd::rule { '-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete': }
    auditd::rule { '-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete': }
    auditd::rule{'-w /etc/sudoers -p wa -k scope': }
    auditd::rule{'-w /etc/sudoers.d -p wa -k scope': }
    auditd::rule{ '-w /var/log/sudo.log -p wa -k actions': }
    auditd::rule{ '-w /sbin/insmod -p x -k modules': }
    auditd::rule{ '-w /sbin/rmmod -p x -k modules': }
    auditd::rule{ '-w /sbin/modprobe -p x -k modules': }
    auditd::rule{ '-a always,exit arch=b64 -S init_module -S delete_module -k modules': }
    if $facts['cisecurity']['suid_sgid_files'] != undef {
      $facts['cisecurity']['suid_sgid_files'].each | String $file | {
        auditd::rule { "-a always,exit -F path='${file}' -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged": }
      }
    } else {
      notice ('Cannot configure auditing of suid/sgid files because required external facts are unavailable. This may be transient.')
    }
    auditd::rule{ '-e 2':
      order => 999,
    }
  }

  if $configure_postfix == 'enabled' {
    class { 'postfix':
      inet_interfaces => 'localhost',
    }
  }

  if $cron == 'enabled' {
    service { 'crond':
      ensure => running,
      enable => true,
    }
  }

  if $configure_rsyslog == 'enabled' {
    class { '::rsyslog':
      perm_file => '0640',
    }
    class { 'rsyslog::client':
      remote_servers => $rsyslog_remote_servers,
    }
    file { '/etc/rsyslog.d/CIS.conf':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $rsyslog_conf,
    }
  }

  if $configure_sshd == 'enabled' {
    service { 'sshd':
      ensure => running,
      enable => true,
    }
    sshd_config { 'Protocol':
      ensure => present,
      value  => $sshd_protocol,
    }
    sshd_config { 'LogLevel':
      ensure => present,
      value  => $sshd_log_level,
    }
    sshd_config { 'X11Forwarding':
      ensure => present,
      value  => $sshd_x11_forwarding,
    }
    sshd_config { 'MaxAuthTries':
      ensure => present,
      value  => $sshd_max_auth_tries,
    }
    sshd_config { 'IgnoreRhosts':
      ensure => present,
      value  => $sshd_ignore_rhosts,
    }
    sshd_config { 'HostbasedAuthentication':
      ensure => present,
      value  => $sshd_hostbased_authentication,
    }
    sshd_config { 'PermitRootLogin':
      ensure => present,
      value  => $sshd_permit_root_login,
    }
    sshd_config { 'PermitEmptyPasswords':
      ensure => present,
      value  => $sshd_permit_empty_passwords,
    }
    sshd_config { 'PermitUserEnvironment':
      ensure => present,
      value  => $sshd_permit_user_environment,
    }
    $ciphers = join($sshd_permitted_ciphers, ',')
    sshd_config { 'Ciphers':
      ensure => present,
      value  => $ciphers,
    }
    sshd_config { 'MACs':
      ensure => present,
      value  => $sshd_permitted_macs,
    }
    sshd_config { 'ClientAliveInterval':
      ensure => present,
      value  => $sshd_client_alive_interval,
    }
    sshd_config { 'ClientAliveCountMax':
      ensure => present,
      value  => $sshd_client_alive_count_max,
    }
    sshd_config { 'LoginGraceTime':
      ensure => present,
      value  => $sshd_login_grace_time,
    }
    sshd_config { 'BannerFile':
      ensure => present,
      value  => $sshd_banner_file,
    }
  }

  if $configure_time == 'enabled' {
    case $time_service_provider {
      'ntp': {
        class { '::ntp':
          service_ensure => running,
          service_enable => true,
          servers        => $time_service_servers,
          restrict       => $ntp_service_restrictions,
        }
        file { '/etc/sysconfig/ntpd':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => 'OPTIONS="-g -u ntp:ntp"',
        }
        class { '::chrony':
          service_ensure => stopped,
          service_enable => false,
        }
      }
      'chrony': {
        class { '::chrony':
          service_ensure => running,
          service_enable => true,
          servers        => $time_service_servers,
        }
        file { '/etc/sysconfig/chronyd':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => 'OPTIONS="-u chrony"',
        }

        class { '::ntpd':
          service_ensure => stopped,
          service_enable => false,
        }
      }
      default: {
        fail ("The time_service_provider parameter only accepts 'ntp' or 'chrony'.")
      }
    }
  }

  $service_list = [
    'avahi-daemon.service',
    'cups.service',
    'dhcpd.service',
    'dovecot.service',
    'httpd.service',
    'named.service',
    'nfs.service',
    'ntalk.service',
    'rexec.socket',
    'rhnsd.service',
    'rlogin.socket',
    'rpcbind.service',
    'rsh.socket',
    'rsyncd.service',
    'slapd.service',
    'smb.service',
    'snmpd.service',
    'squid.service',
    'telnet.socket',
    'tftp.socket',
    'vsftpd.service',
    'ypserv.service',
  ]
  $service_list.each | String $service | {
    $uscore_service1 = regsubst($service, '-', '_')
    $uscore_service2 = regsubst($uscore_service1, '.service', '')
    $uscore_service = regsubst($uscore_service2, '.socket', '')
    if getvar($uscore_service) == 'enabled' {
      service { $service:
        ensure => started,
        enable => true,
      }
    } else {
      service { $service:
        ensure => stopped,
        enable => false,
      }
    }
  }

}