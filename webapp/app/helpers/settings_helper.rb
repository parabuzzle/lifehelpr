module SettingsHelper

def get_local_time(def_rem, time_zone)
  @def_rem = def_rem
  time = get_12_hour_hash(@def_rem.hour, @def_rem.min)
  local = get_24_hour_hash_local(time["hour"],time["min"], time["suf"],time_zone)
  local_time = get_12_hour_hash(local["hour"], local["min"])
  @hour = local_time["hour"]
  @min = local_time["min"]
  @suf = local_time["suf"]
end

end
