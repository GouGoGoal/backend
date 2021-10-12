#!/bin/bash

eth=`ip route |grep default|grep -oE "dev.*"|awk '{print $2}'`

#封禁BT
iptables -A OUTPUT -o $eth -m string --string "torrent" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "peer_id=" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "announce" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "info_hash" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "get_peers" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "find_node" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "announce_peer" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "BitTorrent protocol" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "magnet:" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "xunlei" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "sandai" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "Thunder" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -o $eth -m string --string "XLLiveUD" --algo bm --to 65535 -j DROP

iptables -A INPUT -i $eth -m string --string "torrent" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "peer_id=" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "announce" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "info_hash" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "get_peers" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "find_node" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "announce_peer" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "BitTorrent protocol" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "magnet:" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "xunlei" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "sandai" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "Thunder" --algo bm --to 65535 -j DROP
iptables -A INPUT -i $eth -m string --string "XLLiveUD" --algo bm --to 65535 -j DROP
