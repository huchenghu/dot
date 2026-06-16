#!/bin/bash

# 配置防火墙
#   设置默认防火墙区域为DROP，屏蔽ICMP
#   对局域网IP分设public区域，默认DROP，屏蔽ICMP，放行公开服务
#   对home区域放行常用服务

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

echo "resetto_default      : $resetto_default"
echo "resetto_drop         : $resetto_drop"
echo "newservice_proxy     : $newservice_proxy"

echo
if [[ $publiczone -eq 1 ]]; then
  echo "publiczone           : $publiczone"
  echo "publiczone_sources   :"
  for zonesource in ${publiczone_sources[@]}; do
    echo "                     : $zonesource"
  done
  echo "publiczone_services  :"
  for zoneservice in ${publiczone_services[@]}; do
    echo "                     : $zoneservice"
  done
fi

echo
if [[ $homezone -eq 1 ]]; then
  echo "homezone             : $homezone"
  echo "homezone_sources     :"
  for zonesource in ${homezone_sources[@]}; do
    echo "                     : $zonesource"
  done
  echo "homezone_services    :"
  for zoneservice in ${homezone_services[@]}; do
    echo "                     : $zoneservice"
  done
fi

echo
echo "[ENV] confirm environment?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "n" || "$prompt" == "N" ]]; then
  exit 1
fi

# --------------------------------------------------------------------------}}}

# firewalld ----------------------------------------------------------------{{{

echo
echo "[firewalld] sudo systemctl enable --now firewalld"
sudo systemctl enable --now firewalld
echo "sleep"
sleep 2

echo
if [[ $resetto_default -eq 1 ]]; then
  echo
  echo "[firewalld] reset to default"
  echo "sudo firewall-cmd --reset-to-defaults"
  sudo firewall-cmd --reset-to-defaults
  echo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echo "sudo firewall-cmd --list-all-zones"
  sudo firewall-cmd --list-all-zones
fi

echo
if [[ $resetto_drop -eq 1 ]]; then
  echo
  echo "[firewalld] reset default zone DROP"
  echo "sudo firewall-cmd --reset-to-defaults"
  sudo firewall-cmd --reset-to-defaults
  echo "sudo firewall-cmd --get-default-zone"
  sudo firewall-cmd --get-default-zone
  echo "sudo firewall-cmd --set-default-zone=drop"
  sudo firewall-cmd --set-default-zone=drop
  echo "sudo firewall-cmd --permanent --zone=drop --add-icmp-block-inversion"
  sudo firewall-cmd --permanent --zone=drop --add-icmp-block-inversion
  echo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echo "sudo firewall-cmd --list-all"
  sudo firewall-cmd --list-all
fi

echo
if [[ $newservice_proxy -eq 1 ]]; then
  echo
  echo "[firewalld] NEW service: proxy, add port 1080/tcp, 11080/tcp"
  echo "sudo firewall-cmd --permanent --new-service=proxy"
  sudo firewall-cmd --permanent --new-service=proxy
  echo "sudo firewall-cmd --permanent --service=proxy --add-port=1080/tcp"
  sudo firewall-cmd --permanent --service=proxy --add-port=1080/tcp
  echo "sudo firewall-cmd --permanent --service=proxy --add-port=11080/tcp"
  sudo firewall-cmd --permanent --service=proxy --add-port=11080/tcp
  echo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echo "sudo firewall-cmd --info-service=proxy"
  sudo firewall-cmd --info-service=proxy
fi

echo
if [[ $publiczone -eq 1 ]]; then
  echo
  echo "[firewalld] clean public zone, set target to DROP"
  echo "sudo firewall-cmd --permanent --zone=public --remove-service=ssh"
  sudo firewall-cmd --permanent --zone=public --remove-service=ssh
  echo "sudo firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client"
  sudo firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client
  echo "sudo firewall-cmd --permanent --zone=public --add-icmp-block-inversion"
  sudo firewall-cmd --permanent --zone=public --add-icmp-block-inversion
  echo "sudo firewall-cmd --permanent --zone=public --set-target=DROP"
  sudo firewall-cmd --permanent --zone=public --set-target=DROP

  echo
  echo "[firewalld] add public zone sources"
  for zonesource in ${publiczone_sources[@]}; do
    echo "sudo firewall-cmd --permanent --zone=public --add-source=$zonesource"
    sudo firewall-cmd --permanent --zone=public --add-source="$zonesource"
  done
  unset zonesource

  echo
  echo "[firewalld] add public zone services"
  for zoneservice in ${publiczone_services[@]}; do
    echo "sudo firewall-cmd --permanent --zone=public --add-service=$zoneservice"
    sudo firewall-cmd --permanent --zone=public --add-service="$zoneservice"
  done
  unset zoneservice

  echo
  echo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echo "sudo firewall-cmd --list-all --zone=public"
  sudo firewall-cmd --list-all --zone=public
fi

echo
if [[ $homezone -eq 1 ]]; then
  echo
  echo "[firewalld] add home zone sources"
  for zonesource in ${homezone_sources[@]}; do
    echo "sudo firewall-cmd --permanent --zone=home --add-source=$zonesource"
    sudo firewall-cmd --permanent --zone=home --add-source="$zonesource"
  done
  unset zonesource

  echo
  echo "[firewalld] add home zone services"
  for zoneservice in ${homezone_services[@]}; do
    echo "sudo firewall-cmd --permanent --zone=home --add-service=$zoneservice"
    sudo firewall-cmd --permanent --zone=home --add-service="$zoneservice"
  done
  unset zoneservice

  echo
  echo "sudo firewall-cmd --reload"
  sudo firewall-cmd --reload
  echo "sudo firewall-cmd --list-all --zone=home"
  sudo firewall-cmd --list-all --zone=home
fi

echo
echo "sudo firewall-cmd --list-all-zones"
sudo firewall-cmd --list-all-zones
echo "sudo firewall-cmd --get-active-zones"
sudo firewall-cmd --get-active-zones

# --------------------------------------------------------------------------}}}
