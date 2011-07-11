Given /^I am logged in$/ do
   Given %{I am on the sign in page}
   Given %{I fill in "test" for "username"}
   Given %{I fill in "testing" for "password"}
   Given %{I press "Sign in"}
end



