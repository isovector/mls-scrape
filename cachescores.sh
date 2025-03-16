set -e

DB="artifacts/db.db"
./parse.sh > artifacts/out.csv
sqlite-utils insert --csv  $DB properties artifacts/out.csv

while IFS=$'\x1F' read -d $'\x1E' -ra row; do
  ADDRESS="${row[0]}"
  echo $ADDRESS
  break
  LAT="${row[1]}"
  LNG="${row[2]}"
  ./scores.sh "${ADDRESS}" "${LAT}" "${LNG}" | jq -s -r 'add' >> cache/raw.csv
  sleep 2s
done < <(sqlite3 -batch -noheader -ascii artifacts/db.db \
          -cmd "attach 'cache/scores.db' as scores;" \
            'SELECT p.address, latitude, longitude FROM properties as p left join scores.scores as s on p.address = s.address where s.address is null;')

