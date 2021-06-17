#! /bin/bash

# this script installs all dependencies and requirements for ArcGIS Engine as of 11/30/2016.

yum -y groupinstall "X Window System" "Compatibility libraries" "Development tools"
yum -y install compat-libstdc++-33 compat-libstdc++-33.i686
yum -y install compat-libstdc++-296 compat-libstdc++-296.i686
yum -y install compat-libf2c-34 compat-libf2c-34.i686
yum -y install libXp libXp.i686
yum -y install libXp-devel libXp-devel.i686
yum -y install libXtst libXtst.i686 libXtst-devel libXtst-devel.i686
yum -y install freeglut freeglut.i686
yum -y install freeglut freeglut.i686
yum -y install redhat-lsb redhat-lsb.i686
yum -y install cairo cairo.i686
yum -y install compat-libf2c-34 compat-libf2c-34.i686
yum -y install compat-gcc-34
yum -y install gmp gmp.i686
yum -y install glibc glibc.i686
yum -y install gtk2  gtk2.i686 gtk2-devel gtk2-devel.i686
yum -y install libgfortran44 libgfortran44.i686
yum -y install libgfortran libgfortran.i686
yum -y install libidn libidn.i686
yum -y install libstdc++ libstdc++.i686
yum -y install mesalibGL mesa-libGL.i686 mesa-libGLU mesa-libGLU.i686
yum -y install openldap openldap.i686
yum -y install openssl  openssl.i686

#if you're installing 10.2.x you also need to install readline: 

yum -y install readline readline.i686

sudo mkdir /usr/local/share/macrovision
sudo mkdir /usr/local/share/macrovision/storage

echo "Granting access to storage directory"
chmod 777 /usr/local/share/macrovision/storage

echo "ArcGIS Engine Linux pre-requisites installation complete!"
