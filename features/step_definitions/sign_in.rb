Given /^I am logged in$/ do
   Given %{I am on the sign in page}
   Given %{I fill in "jackbauer" for "username"}
   Given %{I fill in "Ve4yStr0ngPa55w0rd!43sdfs" for "input_password"}
   Given %{I press "Sign in"}
end

When /^I wait$/ do
  wait_for_ajax
  sleep 1
end

