DB="artifacts/db.db"
rm $DB
./parse.sh > artifacts/out.csv
sqlite-utils insert --csv  $DB properties artifacts/out.csv
sqlite-utils transform $DB properties --type latitude FLOAT
sqlite-utils transform $DB properties --type longitude FLOAT
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
sqlite-utils extract $DB properties city
sqlite-utils extract $DB properties type
sqlite-utils extract $DB properties facing
sqlite-utils extract $DB properties zoning
sqlite-utils extract $DB properties view
