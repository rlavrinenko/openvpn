#!/bin/bash
PJDIR=/openvpn
RSADIR=/openvpm/rsa
VARS=/openvpm/rsa/vars
OVPCFG=/etc/openvpn
apt install openvpn wget -y
CERTDIR=$RSADIR/pki/issued
KEYDIR=$RSADIR/pki/private
REQDIR=$RSADIR/pki/reqs
mkdir $PJDIR
cd PJDIR
wget https://github.com/rlavrinenko/openvpn/raw/main/rsa/EasyRSA-3.0.8.tgz
tar zxvf EasyRSA-3.0.8.tgz
mv EasyRSA-3.0.8 rsa
cd $RSADIR
wget https://raw.githubusercontent.com/rlavrinenko/openvpn/main/rsa/vars
echo -n "enter keysize: "
read keysize
echo -n "enter CA key expire days: "
read CAEXPIRE
echo -n "enter keys expire days: "
read KEYEXPIRE
echo "export KEY_SIZE=$keysize" >> $VARS
echo "export CA_EXPIRE=$CAEXPIRE" >> $VARS
echo "export KEY_EXPIRE=$KEYEXPIRE" >> $VARS
cd $RSADIR
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
cp $KEYDIR/server.key $OVPCFG
./easyrsa import-req $REQDIR/server.req
./easyrsa sign-req server server
cp pki/ca.crt $OVPCFG
cp $CERTDIR/server.crt $OVPCFG
./easyrsa gen-dh
cp pki/dh.pem $OVPCFG
cd $OVPCFG
wget https://raw.githubusercontent.com/rlavrinenko/openvpn/main/openvpn/server.conf
echo -n "Enter vpn port: "
read vpnport
echo -n "Enter vpn network (ex: 10.10.10.0): "
read vpnnet
echo -n "Enter vpn mask (ex: 255.255.255.0): "
read vpnmask
echo -n "Enter local network for push (ex: 192.168.15.0): "
read localnet
echo -n "Enter Local network mask (ex: 255.255.255.0): "
read localmask
sed -i -e 's/PORT/$vpnport/g' server.conf
sed -i -e 's/VPNIP/$vpnnet/g' server.conf 
sed -i -e 's/VPNMASK/$vpnmask/g' server.conf 
sed -i -e 's/LOCALIP/$localnet/g' server.conf 
sed -i -e 's/LOCALMASK/$localmask/g' server.conf 