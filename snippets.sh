#remove svn folders
find . -name ".svn" -exec rm -rf {} \;

#show active dhcp leases
cat /var/lib/dhcp/dhcpd.leases

#download multiple files with curl
curl -O "https://az412801.vo.msecnd.net/vhd/IEKitV1_Final/VirtualBox/OSX/IE10_Win8/IE10.Win8.For.MacVirtualBox.part{1.sfx,2.rar,3.rar}"
