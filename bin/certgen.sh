#!/usr/bin/env bash

SCRIPT="$(readlink --canonicalize-existing "$0")"
SCRIPTPATH="$(dirname "$SCRIPT")"
SSL_PATH="${SCRIPTPATH}/../ssl"

CERT_PATH="${SSL_PATH}/certs"
SSL_CONF_PATH="${SSL_PATH}/conf"

CA_PATH="${SSL_PATH}/ca"
CA_KEY=${CA_PATH}/ca.key 
CA_CERT=${CA_PATH}/ca.crt 

if  [[ ! -f ${CA_CERT} ]] || [[ ! -f ${CA_KEY} ]]; then

    openssl genrsa -out ${CA_KEY} 2048
    openssl req -x509 -new -nodes \
            -key ${CA_KEY} -subj "/C=GR/L=ATTICA" \
            -days 1825 -out ${CA_CERT}

fi

CERT_BASENAME="www"

CERTIFICATE_PATH=${CERT_PATH}/${CERT_BASENAME}.crt
KEY_PATH=${CERT_PATH}/${CERT_BASENAME}.key
SIGNING_REQUEST=${CERT_PATH}/${CERT_BASENAME}.csr


echo "CREATING CERTIFICATE"

openssl req -new -sha512 -keyout ${KEY_PATH} -nodes -out ${SIGNING_REQUEST} -config ${SSL_CONF_PATH}/ssl_conf
echo "SIGNING CERTIFICATE using CA"
ls -l ${SIGNING_REQUEST}
openssl x509 -req -days 9000 -startdate  -sha512 -in ${SIGNING_REQUEST} -CAkey ${CA_KEY} -CA ${CA_CERT} -CAcreateserial -extfile ${SSL_CONF_PATH}/v3.sign -out ${CERTIFICATE_PATH} 

rm -rf ${SIGNING_REQUEST}

echo "#######################################"
echo "IMPORT these cert into your system as CA cert:"
echo -e "\033[0;96m${CA_CERT}\033[0m"
echo
echo The generated certificates are:
echo -e "CERT: \033[0;96m${CERTIFICATE_PATH}\033[0m"
echo -e "KEY: \033[0;96m${KEY_PATH}\033[0m"