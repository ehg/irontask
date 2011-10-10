require 'machinist/active_record'

User.blueprint do
  username { "test" }
  password { "cf80cd8aed482d5d1527d7dc72fceff84e6326592848447d2dc0b0e87dfc9a90" }
  magic_word { "please" }
end


Task.blueprint do
  content { "this should be encrypted stuff, it's entirely meaningless to this rails app" }
  done { true }
end
