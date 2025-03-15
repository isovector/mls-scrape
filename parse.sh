jq '[.data.listings.listings.[]
  #| select(.property.ListPrice < 1200000)
  #| select(.property.City == "Victoria" or .property.City == "Saanich" or .property.City == "Esquimalt")
  #| select(.property.LivingArea >= 1100)
  # | select(.property.YearBuilt <= 1946)
  | {  address:
        ( .property.StreetNumber
        + " "
        + .property.StreetName
        + " "
        + .property.StreetSuffix
        )
    , city: .property.City
    , price: .property.ListPrice
    , fees: (.property.AssociationFee // 0)
    , tax : .property.TaxAnnualAmount
    , assessed : .property.TaxAssessedValue
    , sqft: .property.LivingArea
    , lot: .property.LotSizeArea
    , year: .property.YearBuilt
    , beds: .property.BedroomsTotal
    , baths: .property.BathroomsTotalInteger
    , rooms: .property.RoomsTotal
    , floors:  (.property.StoriesTotal // (.rooms|map(.RoomLevel)|unique|length))
    , type: .property.PropertySubType
    , dining: any(.rooms.[]; any((.RoomType // []).[]; . == "DiningRoom"))
    , fireplace: .property.FireplaceYN
    , patio:
        (any(.rooms.[]
           ; any((.RoomType // []).[]; . == "Patio" or . == "Deck" or . == "Balcony")
           )
        or any((.property.ExteriorFeatures // []).[]; . == "Balcony" or . == "Deck"))
    , workshop:
        (any(.rooms.[]
           ; any((.RoomType // []).[]; . == "Workshop")
           ) or .property.GarageYN)
    , garden: any((.property.ExteriorFeatures // []).[]; . == "Garden")
    , facing: .property.DirectionFaces
    , zoning: .property.ZoningDescription
    , fireplace: .property.FireplaceYN
    , view: (.property.View // []) | join(",")
    , onMarket: .property.DaysOnMarket
    , link: ("https://portal.onehome.com/en-CA/property/" + .id + '"$(<secrets/token)"')
    , floorplan:
        (( .sourceMedia .[] | select(.LongDescription | ascii_downcase == "floor plans") .sourceMediaLink
        ) // "") # .sourceMedia)
    , latitude: .property.Latitude
    , longitude: .property.Longitude
    }]
      | (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv
    ' -r < artifacts/json
