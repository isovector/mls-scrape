LAT=$1
LNG=$2

echo "["

curl "https://services.onehome.com/api/locallogic/scores?lat=${LAT}&lng=${LNG}&locale=en" \
  -H 'accept: application/json' \
  -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
  -H "$(<secrets/auth)" \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-gpc: 1' \
  -H 'withcredentials: true' \
  | jq '.data.location | [ keys[] as $k | { $k: .[$k].value } ] | add'
echo ","

curl "https://api.locallogic.co/v3/scores?lat=${LAT}&lng=${LNG}&include=groceries%2Crestaurants%2Cshopping%2Ccafes&geography_levels=20%2C30&location_scores_rounding=none&language=en" \
  -H 'accept: application/json' \
  -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
  -H "$(<secrets/authv3)" \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-gpc: 1' \
  -H 'withcredentials: true' \
  | jq '.data.location | [ keys[] as $k | { $k: .[$k].value } ] | add'

echo "]"
