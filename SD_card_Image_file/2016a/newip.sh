# Flush existing config
ip addr flush dev eth0
ip link set dev eth0 down
# Set up new config
ip addr add 192.168.3.3/24 dev eth0
ip link set eth0 address 00:0A:35:00:01:23
ip route add default via 192.168.3.1
ip link set dev eth0 up
