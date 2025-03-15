DB="artifacts/db.db"
rm $DB
./parse.sh > artifacts/out.csv

sqlite-utils insert --csv  $DB properties artifacts/out.csv
# update types

sqlite-utils transform $DB properties --type latitude FLOAT
sqlite-utils transform $DB properties --type longitude FLOAT
sqlite-utils transform $DB properties --type price INTEGER
sqlite-utils transform $DB properties --type fees INTEGER
sqlite-utils transform $DB properties --type tax INTEGER
sqlite-utils transform $DB properties --type assessed INTEGER
sqlite-utils transform $DB properties --type sqft INTEGER
sqlite-utils transform $DB properties --type lot FLOAT
sqlite-utils transform $DB properties --type year INTEGER
sqlite-utils transform $DB properties --type beds INTEGER
sqlite-utils transform $DB properties --type baths INTEGER
sqlite-utils transform $DB properties --type rooms INTEGER
sqlite-utils transform $DB properties --type floors INTEGER
sqlite-utils transform $DB properties --type onMarket INTEGER

./scoreparse.sh
