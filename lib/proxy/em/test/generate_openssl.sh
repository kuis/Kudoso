mkdir -p ../certs/temp/private

# Generate a private key
# openssl genrsa -out ../certs/temp/private/cakey.key 1024
#
# # Generate a self signed cert
# openssl req -new -x509 -nodes -sha1 -days 1825 -key ../certs/temp/private/cakey.key -out ../certs/temp/cacert.pem


# Intermediate
# mkdir -p ../certs/temp/inter
# openssl genrsa -out ../certs/temp/inter/cakey.pem 1024
#
# openssl req -new -sha1 -key ../certs/temp/inter/cakey.pem -out ../certs/temp/inter/ca2013.csr
#

openssl ca -extensions v3_ca -days 365 -out ../certs/temp/inter/ca2013.crt -in ../certs/temp/inter/ca2013.csr


mv ../certs/temp/inter/ca2013.crt ../certs/temp/inter/ca2013.pem