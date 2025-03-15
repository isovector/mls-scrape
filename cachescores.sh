set -e

while IFS=$'\x1F' read -d $'\x1E' -ra row; do
  ADDRESS="${row[0]}"
  echo $ADDRESS
  LAT="${row[1]}"
  LNG="${row[2]}"
  ./scores.sh "${ADDRESS}" "${LAT}" "${LNG}" | jq -s -r 'add' >> cache/raw.csv
  sleep 2s
done < <(sqlite3 -batch -noheader -ascii artifacts/db.db 'SELECT address, latitude, longitude FROM properties')

