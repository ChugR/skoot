#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License
#

D=$1

echo $D

echo "$2-password" | cat > $D/tls.$2.pw
openssl genrsa -aes256 -passout file:$D/tls.$2.pw -out $D/tls.$2.key 4096

openssl req -new -key $D/tls.$2.key -passin file:$D/tls.$2.pw -out $D/tls.$2.csr -subj "/C=US/ST=CA/L=San Francisco/O=Red Hat Inc./CN=inter-router-demo2-amq.apps.summit.sysdeseng-$2.com"

openssl x509 -req -in $D/tls.$2.csr -CA $D/ca.crt -CAkey $D/ca.key -CAcreateserial -days 9999 -out $D/tls.$2.crt -passin pass:ca-password

openssl verify -verbose -CAfile $D/ca.crt $D/tls.$2.crt

#rm -f $D/*.csr .srl $D/ca.key