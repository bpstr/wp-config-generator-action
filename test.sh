chmod +x generate.sh

rm wp-config.php
DB_HOST=localhost DB_NAME=somename DB_USER=username  DB_PASS=passs ./generate.sh wp --google-api-key=gkey --google-secret=gsec

