jq '[.data.listings.listings.[]
  | select(.property.ListPrice < 1200000)
  | select(.property.City == "Victoria" or .property.City == "Saanich" or .property.City == "Esquimalt")
  | select(.property.LivingArea >= 1100)
  # | select(.property.YearBuilt <= 1946)
  | { score: 50
    , link: ("https://portal.onehome.com/en-CA/property/" + .id + '"$(<token)"')
    , address:
        ( .property.StreetNumber
        + " "
        + .property.StreetName
        + " "
        + .property.StreetSuffix
        )
    , floorplan:
        (( .sourceMedia .[] | select(.LongDescription | ascii_downcase == "floor plans") .sourceMediaLink
         ) // .sourceMedia)
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
    , stories: (.rooms|map(.RoomLevel)|unique)|join(",")
    , type: .property.PropertySubType
    , dining: any(.rooms.[]; any((.RoomType // []).[]; . == "DiningRoom"))
    , fireplace: .property.FireplaceYN
    , patio:
        (any(.rooms.[]
           ; any((.RoomType // []).[]; . == "Patio" or . == "Deck" or . == "Balcony")
           )
        or any((.property.ExteriorFeatures // []).[]; . == "Balcony" or . == "Deck"))
    , workshop:
        any(.rooms.[]
           ; any((.RoomType // []).[]; . == "Workshop")
           )
    , garden: any((.property.ExteriorFeatures // []).[]; . == "Garden")
    , facing: .property.DirectionFaces
    , zoning: .property.ZoningDescription
    }]
#      | (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv
    ' < json
