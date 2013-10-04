#remove svn folders
find . -name ".svn" -exec rm -rf {} \;

#show active dhcp leases
cat /var/lib/dhcp/dhcpd.leases
