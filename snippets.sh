#remove svn folders
find . -name ".svn" -exec rm -rf {} \;

#show active dhcp leases
cat /var/lib/dhcp/dhcpd.leases

#download multiple files with curl
curl -O "https://az412801.vo.msecnd.net/vhd/IEKitV1_Final/VirtualBox/OSX/IE10_Win8/IE10.Win8.For.MacVirtualBox.part{1.sfx,2.rar,3.rar}"

#batch resize images with imagemagick
$ for i in $( ls *.jpg); do convert -resize 50% $i re_$i; done

#set symfony permissions
APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd' | grep -v root | head -1 | cut -d\  -f1`
sudo setfacl -R -m u:$APACHEUSER:rwX -m u:`whoami`:rwX app/cache app/logs
sudo setfacl -dR -m u:$APACHEUSER:rwX -m u:`whoami`:rwX app/cache app/logs


#inline copy replace 
sed -i 's/foo/bar/g' file


#show all files in finder 
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

#disable mouse accel on mac os
defaults write .GlobalPreferences com.apple.mouse.scaling -1
