#!/bin/bash

openssl genrsa -out root.key 2048
openssl req -new -key root.key -out root.csr -config root_req.config
openssl ca -in root.csr -out root.pem -config root.config -selfsign -extfile ca.ext -days 1095

openssl genrsa -out intermediate.key 2048
openssl req -new -key intermediate.key -out intermediate.csr -config intermediate_req.config
openssl ca -in intermediate.csr -out intermediate.pem -config root.config -days 730

openssl genrsa -out leaf.key 2048
openssl req -new -key leaf.key -out leaf.csr -config leaf_req.config
openssl ca -in leaf.csr -out leaf.pem -config intermediate.config -extfile ca.ext -days 365

mkdir -p out
mv *.pem out
mv *.key out
mv *.csr out

openssl verify -CAfile <(cat out/root.pem out/intermediate.pem) out/leaf.pem
