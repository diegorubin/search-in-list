entries = {
   -- in list
   "00001102669",
   "00001533453",
   "00008989510",
   "00014761068",
   -- not in list
   "00001102679",
   "02001533453",
   "01108989510",
   "10014761068"
}

total = 8
counter = 0

request = function()
  path = "/"

  entry = entries[counter % total]

  if entry == nil then
    wrk.headers["X-Entry"] = "10014761068"
  else
    wrk.headers["X-Entry"] = entry
  end


  counter = counter + 1

  return wrk.format(nil, path)
end
