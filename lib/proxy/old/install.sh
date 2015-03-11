30776

svn co svn://svn.openwrt.org/openwrt/trunk@30776 openwrt-r30776
wget http://www.znau.edu.ua/temp/asus-rt-n16/2012-02-10T15-42/2012-02-10T15-42_openwrt4716.tar.bz2
tar xjf 2012-02-10T15-42_openwrt4716.tar.bz2
cd openwrt-r30776
patch -p1 < ../2012-02-10T15-42/000-openwrt4716-TARGET_brcm4716-clone-brcm47xx.patch
patch -p1 < ../2012-02-10T15-42/001-openwrt4716-TARGET_brcm4716.patch
patch -p1 < ../2012-02-10T15-42/002-openwrt4716-TARGET_brcm4716-deps.patch



--- more recent ----

svn co svn://svn.openwrt.org/openwrt/trunk@32096 openwrt-r32096
wget http://www.znau.edu.ua/temp/asus-rt-n16/2012-05-28T17-30/2012-05-28T17-30_openwrt4716.tar.bz2
tar xjf 2012-05-28T17-30/2012-05-28T17-30_openwrt4716.tar.bz2
cd openwrt-r32096
patch -p1 < ../2012-05-28T17-30/000-openwrt4716-TARGET_brcm4716-clone-brcm47xx.patch
patch -p1 < ../2012-05-28T17-30/001-openwrt4716-TARGET_brcm4716.patch
patch -p1 < ../2012-05-28T17-30/002-openwrt4716-TARGET_brcm4716-deps.patch
make menuconfig