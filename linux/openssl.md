# Openssl self signed ssl certificate

## Generate CA private key
```bash
openssl genrsa -out ca.key 2048
```
## Create CA certificate
```bash
openssl req -new -x509 -days 365 -key ca.key -out ca.crt -subj "/CN=MQTT CA"
```
## Generate server private key
```bash
openssl genrsa -out server.key 2048
```
## Create server certificate signing request (CSR)
**use your domain/ip**
```bash
openssl req -new -key server.key -out server.csr -subj "/CN=domain name"
```
## Sign the server certificate with the CA
```bash
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365
```
## Generate client private key
```bash
openssl genrsa -out client.key 2048
```
## Create client certificate signing request (CSR)
```bash
openssl req -new -key client.key -out client.csr -subj "/CN=MQTTClient"
```
## Sign the client certificate with the CA
```bash
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365
```
## (Optional) Create .pem files by concatenating key and certificate
```bash
cat server.key server.crt > server.pem
cat client.key client.crt > client.pem
```
