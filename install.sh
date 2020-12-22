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
wget https://github.com/rlavrinenko/ubuntu_openvpn/raw/main/rsa/EasyRSA-3.0.8.tgz
tar zxvf EasyRSA-3.0.8.tgz
mv EasyRSA-3.0.8 rsa
cd $RSADIR
wget https://raw.githubusercontent.com/rlavrinenko/ubuntu_openvpn/main/rsa/vars
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
