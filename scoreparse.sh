cat cache/raw.csv \
| jq -s '
[.[] |
  { address                   : .address
  , score_high_schools        : .high_schools.value
  , score_primary_schools     : .primary_schools.value
  , score_transit_friendly    : .transit_friendly.value
  , score_groceries           : .groceries.value
  , score_restaurants         : .restaurants.value
  , score_pedestrian_friendly : .pedestrian_friendly.value
  , score_cycling_friendly    : .cycling_friendly.value
  , score_car_friendly        : .car_friendly.value
  , score_vibrant             : .vibrant.value
  , score_shopping            : .shopping.value
  , score_daycares            : .daycares.value
  , score_nightlife           : .nightlife.value
  , score_cafes               : .cafes.value
  , score_quiet               : .quiet.value
  }]
  ' > artifacts/dscores.json

sqlite-utils insert cache/scores.db scores artifacts/dscores.json
sqlite3 artifacts/db.db -cmd "attach 'cache/scores.db' as scores;" 'create table materialized as select distinct p.address, * from properties as p inner join scores.scores as s on s.address = p.address; select * from materialized;'


DB="artifacts/db.db"
sqlite-utils extract $DB materialized city
sqlite-utils extract $DB materialized type
sqlite-utils extract $DB materialized facing
sqlite-utils extract $DB materialized zoning
sqlite-utils extract $DB materialized view

sqlite-utils enable-fts artifacts/db.db materialized description
