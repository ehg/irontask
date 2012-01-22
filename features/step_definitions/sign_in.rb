Given /^I am logged in$/ do
   step %{I am on the sign in page}
   step %{I fill in "jackbauer" for "username"}
   step %{I fill in "Ve4yStr0ngPa55w0rd!43sdfs" for "input_password"}
   step %{I press "Sign in"}
end

When /^I wait$/ do
  wait_for_ajax
  sleep 1
end

