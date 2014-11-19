# == Define: ulimit::rule
#
# === Parameters:
#
# $ulimit_domain::  Domain
#                   <domain> can be:
#                     - an user name
#                     - a group name, with @group syntax
#                     - the wildcard *, for default entry
#                     - the wildcard %, can be also used with %group syntax,
#                       for maxlogin limit
#                     - NOTE: group and wildcard limits are not applied to root.
#                       To apply a limit to the root user, <domain> must be
#                       the literal username root.
#
# $ulimit_type::    Type
#                   <type> can have the two values:
#                     - "soft" for enforcing the soft limits
#                     - "hard" for enforcing hard limits
#
# $ulimit_item::    Item
#                   <item> can be one of the following:
#                     - core - limits the core file size (KB)
#                     - data - max data size (KB)
#                     - fsize - maximum filesize (KB)
#                     - memlock - max locked-in-memory address space (KB)
#                     - nofile - max number of open files
#                     - rss - max resident set size (KB)
#                     - stack - max stack size (KB)
#                     - cpu - max CPU time (MIN)
#                     - nproc - max number of processes
#                     - as - address space limit (KB)
#                     - maxlogins - max number of logins for this user
#                     - maxsyslogins - max number of logins on the system
#                     - priority - the priority to run user process with
#                     - locks - max number of file locks the user can hold
#                     - sigpending - max number of pending signals
#                     - msgqueue - max memory used by POSIX message queues (bytes)
#                     - nice - max nice priority allowed to raise to values:
#                       [-20, 19]
#                     - rtprio - max realtime priority
#                     - chroot - change root to directory (Debian-specific)
#
# $ulimit_value::   Numerical value
#
# $priority::       Default: 80
#
# $ensure::         Default: present
#
define ulimit::rule (
  $ulimit_domain,
  $ulimit_type,
  $ulimit_item,
  $ulimit_value,
  $priority = 80,
  $ensure = present,
) {
  File {
    group => $::ulimit::config_group,
    owner => $::ulimit::config_user,
  }

  case $ensure {
    'present': {
      file {
        "${::ulimit::config_dir}/${priority}_${name}.conf":
          ensure  => $ensure,
          content => template ('ulimit/rule.conf.erb');
      }
    }

    'absent': {
      file {
        "${::ulimit::config_dir}/${priority}_${name}.conf":
          ensure => $ensure;
      }
    }

    default: {
      fail 'No ensure value found for ulimit rule.'
    }
  }
}

