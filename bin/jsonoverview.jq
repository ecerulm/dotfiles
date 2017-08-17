map_values({"class": type, 
            "value": .})|
  map_values(if .class == "array" then
    . + {"length": .value|length}
  else
    .
  end
  )|
  map_values(del(.value))
  |map_values(
    if .class == "array" then
      "\(.class)[\(.length)]"
    else
      .class
    end
  )
