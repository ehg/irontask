require 'machinist/active_record'

# password plain: testing
# password hash: cf80cd8aed482d5d1527d7dc72fceff84e6326592848447d2dc0b0e87dfc9a90
# server salt: 85082bde708f5e0bf3953f9e430efc902ac36dab581c9cb501ae6d721b474adc
# password stored in db: f5ab6c4066b88eacf0833e641e9e5853aaa6f7d8db12f6363bfcfee8c3154038

User.blueprint do
  username { "test" }
  password { "f5ab6c4066b88eacf0833e641e9e5853aaa6f7d8db12f6363bfcfee8c3154038" }
  #salt { "85082bde708f5e0bf3953f9e430efc902ac36dab581c9cb501ae6d721b474adc" }
end

