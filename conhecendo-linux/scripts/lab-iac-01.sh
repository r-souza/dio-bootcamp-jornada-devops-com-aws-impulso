#!/bin/bash

groups=("GRP_ADM" "GRP_VEN" "GRP_SEC")
admUsers=("carlos" "maria" "joao")
venUsers=("debora" "sebastiana" "roberto")
secUsers=("josefina" "amanda" "rogerio")

# Create Groups
for group in "${groups[@]}"; do
    echo "Adding group ${group}"
    groupadd "${group}"
done

echo

# Create users
echo "Creating ADM users"
for user in "${admUsers[@]}"; do
    echo "Adding user ${user}"
    useradd "${user}" -m -s /bin/bash -G GRP_ADM -p "$(openssl passwd pass123)"
done

echo

echo "Creating VEN users"
for user in "${venUsers[@]}"; do
    echo "Adding user ${user}"
    useradd "${user}" -m -s /bin/bash -G GRP_VEN -p "$(openssl passwd pass123)"
done

echo

echo "Creating SEC users"
for user in "${secUsers[@]}"; do
    echo "Adding user ${user}"
    useradd "${user}" -m -s /bin/bash -G GRP_SEC -p "$(openssl passwd pass123)"
done

echo

# Create directories
echo "Creating /adm directory"
mkdir /adm
chown root:GRP_ADM /adm
chmod 770 /adm

echo "Creating /ven directory"
mkdir /ven
chown root:GRP_VEN /ven
chmod 770 /ven

echo "Creating /sec directory"
mkdir /sec
chown root:GRP_SEC /sec
chmod 770 /sec

echo "Creating /public directory"
mkdir /public
chmod 777 /public