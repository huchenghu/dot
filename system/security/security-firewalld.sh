#!/bin/bash

# 配置防火墙
#   设置默认防火墙区域为DROP，屏蔽ICMP
#   对局域网IP分设public区域，默认DROP，屏蔽ICMP，放行公开服务
#   对home区域放行常用服务

# echo ---------------------------------------------------------------------{{{

# echo [INFO] [WARNING] [ERROR]
# Black         0;30    Dark Gray       1;30
# Red           0;31    Light Red       1;31
# Green         0;32    Light Green     1;32
# Orange        0;33    Yellow          1;33
# Blue          0;34    Light Blue      1;34
# Purple        0;35    Light Purple    1;35
# Cyan          0;36    Light Cyan      1;36
# Light Gray    0;37    White           1;37

echoinfo() {
  #echo -e "\e[32m[INFO]\e[0m"
  unset ARG
  for ARG in "$@"
  do
    echo -e "\e[32m$ARG\e[0m"
  done
  unset ARG
}
echowarning() {
  #echo -e "\e[33m[WARNING]\e[0m"
  unset ARG
  for ARG in "$@"
  do
    echo -e "\e[33m$ARG\e[0m"
  done
  unset ARG
}

echoerror() {
  #echo -e >&2 "\e[31m[ERROR]\e[0m"
  unset ARG
  for ARG in "$@"
  do
    echo -e >&2 "\e[31m$ARG\e[0m"
  done
  unset ARG
}

# --------------------------------------------------------------------------}}}

# env ----------------------------------------------------------------------{{{

resetto_default=0
resetto_drop=1
newservice_proxy=1

publiczone=1
publiczone_sources=(10.0.0.0/8 192.168.0.0/16)
publiczone_services=(https)

homezone=1
homezone_sources=(10.0.0.0/26)
homezone_services=(ssh cockpit https proxy)

echoinfo "resetto_default      : $resetto_default"
echoinfo "resetto_drop         : $resetto_drop"
echoinfo "newservice_proxy     : $newservice_proxy"

echo
if [[ $publiczone -eq 1 ]]; then
  echoinfo "publiczone           : $publiczone"
  echoinfo "publiczone_sources   :"
  for zonesource in ${publiczone_sources[@]}; do
    echoinfo "                     : $zonesource"
  done
  echoinfo "publiczone_services  :"
  for zoneservice in ${publiczone_services[@]}; do
    echoinfo "                     : $zoneservice"
  done
fi

echo
if [[ $homezone -eq 1 ]]; then
  echoinfo "homezone             : $homezone"
  echoinfo "homezone_sources     :"
  for zonesource in ${homezone_sources[@]}; do
    echoinfo "                     : $zonesource"
  done
  echoinfo "homezone_services    :"
  for zoneservice in ${homezone_services[@]}; do
    echoinfo "                     : $zoneservice"
  done
fi

echo
echowarning "[ENV] confirm environment?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "n" || "$prompt" == "N" ]]; then
  exit 1
fi

# --------------------------------------------------------------------------}}}

# firewalld ----------------------------------------------------------------{{{

echo
echoinfo "[firewalld] sudo systemctl enable --now firewalld"
sudo systemctl enable --now firewalld
echoinfo "sleep"
sleep 2

echo
if [[ $resetto_default -eq 1 ]]; then
  echo
  echowarning "[firewalld] reset to default"
  echoinfo "sudo firewall-cmd --reset-to-defaults"
  sudo firewall-cmd --reset-to-defaults
  echoinfo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echoinfo "sudo firewall-cmd --list-all-zones"
  sudo firewall-cmd --list-all-zones
fi

echo
if [[ $resetto_drop -eq 1 ]]; then
  echo
  echowarning "[firewalld] reset default zone DROP"
  echoinfo "sudo firewall-cmd --reset-to-defaults"
  sudo firewall-cmd --reset-to-defaults
  echoinfo "sudo firewall-cmd --get-default-zone"
  sudo firewall-cmd --get-default-zone
  echoinfo "sudo firewall-cmd --set-default-zone=drop"
  sudo firewall-cmd --set-default-zone=drop
  echoinfo "sudo firewall-cmd --permanent --zone=drop --add-icmp-block-inversion"
  sudo firewall-cmd --permanent --zone=drop --add-icmp-block-inversion
  echoinfo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echoinfo "sudo firewall-cmd --list-all"
  sudo firewall-cmd --list-all
fi

echo
if [[ $newservice_proxy -eq 1 ]]; then
  echo
  echowarning "[firewalld] NEW service: proxy, add port 1080/tcp, 11080/tcp"
  echoinfo "sudo firewall-cmd --permanent --new-service=proxy"
  sudo firewall-cmd --permanent --new-service=proxy
  echoinfo "sudo firewall-cmd --permanent --service=proxy --add-port=1080/tcp"
  sudo firewall-cmd --permanent --service=proxy --add-port=1080/tcp
  echoinfo "sudo firewall-cmd --permanent --service=proxy --add-port=11080/tcp"
  sudo firewall-cmd --permanent --service=proxy --add-port=11080/tcp
  echoinfo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echoinfo "sudo firewall-cmd --info-service=proxy"
  sudo firewall-cmd --info-service=proxy
fi

echo
if [[ $publiczone -eq 1 ]]; then
  echo
  echowarning "[firewalld] clean public zone, set target to DROP"
  echoinfo "sudo firewall-cmd --permanent --zone=public --remove-service=ssh"
  sudo firewall-cmd --permanent --zone=public --remove-service=ssh
  echoinfo "sudo firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client"
  sudo firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client
  echoinfo "sudo firewall-cmd --permanent --zone=public --add-icmp-block-inversion"
  sudo firewall-cmd --permanent --zone=public --add-icmp-block-inversion
  echoinfo "sudo firewall-cmd --permanent --zone=public --set-target=DROP"
  sudo firewall-cmd --permanent --zone=public --set-target=DROP

  echo
  echowarning "[firewalld] add public zone sources"
  for zonesource in ${publiczone_sources[@]}; do
    echoinfo "sudo firewall-cmd --permanent --zone=public --add-source=$zonesource"
    sudo firewall-cmd --permanent --zone=public --add-source="$zonesource"
  done
  unset zonesource

  echo
  echowarning "[firewalld] add public zone services"
  for zoneservice in ${publiczone_services[@]}; do
    echoinfo "sudo firewall-cmd --permanent --zone=public --add-service=$zoneservice"
    sudo firewall-cmd --permanent --zone=public --add-service="$zoneservice"
  done
  unset zoneservice

  echo
  echoinfo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echoinfo "sudo firewall-cmd --list-all --zone=public"
  sudo firewall-cmd --list-all --zone=public
fi

echo
if [[ $homezone -eq 1 ]]; then
  echo
  echowarning "[firewalld] add home zone sources"
  for zonesource in ${homezone_sources[@]}; do
    echoinfo "sudo firewall-cmd --permanent --zone=home --add-source=$zonesource"
    sudo firewall-cmd --permanent --zone=home --add-source="$zonesource"
  done
  unset zonesource

  echo
  echowarning "[firewalld] add home zone services"
  for zoneservice in ${homezone_services[@]}; do
    echoinfo "sudo firewall-cmd --permanent --zone=home --add-service=$zoneservice"
    sudo firewall-cmd --permanent --zone=home --add-service="$zoneservice"
  done
  unset zoneservice

  echo
  echoinfo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echoinfo "sudo firewall-cmd --list-all --zone=home"
  sudo firewall-cmd --list-all --zone=home
fi

echo
echoinfo "sudo firewall-cmd --list-all-zones"
sudo firewall-cmd --list-all-zones
echoinfo "sudo firewall-cmd --get-active-zones"
sudo firewall-cmd --get-active-zones

# --------------------------------------------------------------------------}}}
