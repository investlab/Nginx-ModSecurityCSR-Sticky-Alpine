# Alpine Nginx ModSecurity CSR

## This build of Nginx on Alpine includes:

ModSecurity v3, OWASP Core rule set and more cutumize features from NextSec.vn

## You can customize this build by changing the files in the "conf" directory.

- conf/modsec: contains files that link to our owasp rules and contain general modsec settings
- conf/nginx contains our nginx, http, and https config files.
- conf/owasp contains our owasp core rule set config

## How to Run?
cd nginx-modsec-csr
sh auto-deploy-modsec.sh
  
## Dockerhub:
Link : https://github.com/investlab/Nginx-sticky-ThaoPT
