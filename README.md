# Alpine Nginx ModSecurity CSR

This build of Nginx on Alpine includes:

  * ModSecurity v3, OWASP Core Rule Set
  * And more cutumize features from Nexttech.asia

You can customize this build by changing the files in the "conf" directory.

  * conf/modsec: contains files that link to our owasp rules and contain general modsec settings
  * conf/nginx contains our nginx, http, and https config files.
  * conf/owasp contains our owasp core rule set config

How to Run?
  * cd nginx-modsec-csr
  * sh auto-deploy-modsec.sh
  
Dockerhub:

	* Link : https://hub.saobang.vn/harbor/projects/6/repositories/nexttech%2Fnginx-modsecurity-crs
#   N g i n x - s t i c k y - T h a o P T  
 