Given /^I have signed up$/ do
  step %{I go to the sign up page}
  step %{I fill in "username" with "jackbauer"}
  step %{I fill in "password" with "Ve4yStr0ngPa55w0rd!43sdfs"}
  step %{I fill in "confirm_password" with "Ve4yStr0ngPa55w0rd!43sdfs"}
  step %{I wait}
  step %{I press "Sign me up!"}
  end

When /^(?:|I )click "([^"]*)"$/ do |selector|
  find(selector).click
end

When /^I select the "([^"]*)" list$/ do |list|
  wait_for_ajax
  find('#contexts-list').find('span', :text => list).click
  wait_for_ajax
  sleep 1
end

When /^I hold down ctrl$/ do
  sleep 1
  page.driver.browser.action.key_down :command
  sleep 1
end

When /^I release ctrl$/ do
  sleep 1
  page.driver.browser.action.key_up :command
  sleep 1
end

When /^I fill in "([^"]*)" with "([^"]*)" and press enter$/ do |arg1, arg2|
  step %{I fill in "#{arg1}" with "#{arg2}"}
  find_field(arg1).native.send_keys("\n")
  wait_for_ajax
  end


When /^I reload the page$/ do
  visit(current_path)
  wait_for_ajax
end

Given /^I have entered my tasks for today$/ do
  laundry_day = Date.today.to_time.advance(:days => 2).to_date.strftime "%A"
  step %{I select the "Home" list}
  step %{I fill in "add_task" with "Buy cheese and milk and bread for yesterday" and press enter}
  step %{I fill in "add_task" with "Tidy up room for today" and press enter}
  step %{I fill in "add_task" with "Do laundry for #{laundry_day}" and press enter}
  step %{I fill in "add_task" with "Pay credit card bill for 29/12/11" and press enter}
  step %{I select the "Work" list}
  step %{I fill in "add_task" with "Write cucumber features for today" and press enter}
  step %{I fill in "add_task" with "Sort Github repos for 29/12/11" and press enter}
  end

Then /^I should see the date increase by one day$/ do 
  laundry_day = Date.today.to_time.advance(:days => 3).to_date.strftime "%A"
  if page.respond_to? :should
    page.should have_content(laundry_day)
  else
    assert page.has_content?(laundry_day)
  end
end


Then /^I should see the following tasks:$/ do |table|
  table.hashes.each do |hash|
    step %{I should see "#{hash["Task"]}"}
    if hash["Task"] = "Do laundry"
      laundry_day = Date.today.to_time.advance(:days => 2).to_date.strftime "%A"
      step %{I should see "#{laundry_day}"}
    else
      step %{I should see "#{hash["Date"]}"}
    end
  end
end

When /^I mark "([^"]*)" as done$/ do |task_name|
  sleep 1 #wait for transition to finish
  command = %Q{
   $("div.task_text:contains('#{task_name}')").parent().parent().find('.tick').mouseover()
  }
  page.execute_script command
  find('div', :text => task_name).find(:xpath, './/../..').find('.tick').click
end

Then /^I should see "([^"]*)" crossed out$/ do |task_name|
  find('div', :text => task_name).has_css?('.done-task').should be_true
end

When /^I put off "([^"]*)"$/ do |task_name|
  sleep 1 #wait for transition to finish
  command = %Q{
   $("div.task_text:contains('#{task_name}')").parent().parent().find('.putoff').mouseover()
  }
  page.execute_script command
  find('div', :text => task_name).find(:xpath, './/../..').find('.putoff').click

end

When /^I double click on the "([^"]*)" date$/ do |task_date|
  sleep 1 #wait for transition to finish
  command = %Q{
   $("div.task_date:contains('#{task_date}')").dblclick()
  }
  page.execute_script command
end

When /^I double click on "([^"]*)"$/ do |task_text|
  wait_for_ajax
  sleep 1
  command = %Q{
   $("div.task_text:contains('#{task_text}')").dblclick()
  }
  page.execute_script command
end

When /^I drag the "([^"]*)" task to the rubbish bin$/ do |task_name|
  page.execute_script "(new Privydo.Views.Rubbish).render()"
  wait_for_ajax
  task_li = find(:xpath, "//div[text()='#{task_name}']/../..")
  first_bin = find('div.rubbish')
  task_li.drag_to first_bin
end

Then /^I should( not)? see the "([^"]*)" list( selected)?$/ do |see, list, selected|
  if !see
    step %{I should see "#{list}"}
    if selected
      li = find(:xpath, "//li[@class='selected']/div/span[text()='#{list}']")
      li.should_not be_nil
    end
  else
    if see and selected
      lambda {find(:xpath, "//li[@class='selected']/div/span[text()='#{list}']")}.should raise_error
    else
      step %{I should not see "#{list}"}
    end
  end
end

Then /^I should see an input box$/ do
  find_field('context_input').should_not be_nil
end

When /^I double click the "([^"]*)" list$/ do |list|
  wait_for_ajax
  sleep 1
  command = %Q{
   $("span:contains('#{list}')").click();
   $("span:contains('#{list}')").click();
  }
  page.execute_script command
  wait_for_ajax
  sleep 2
end

When /^I drag the "([^"]*)" list to the rubbish bin$/ do |list|
  page.execute_script "(new Privydo.Views.Rubbish).render()"
  wait_for_ajax
  list_li = find(:xpath, "//li/div/span[text()='#{list}']")
  first_bin = find('div.rubbish')
  list_li.drag_to first_bin
end

def wait_for_ajax(timeout = 5) #timeout in seconds
  page.wait_until(timeout) do 
    page.evaluate_script 'jQuery.active == 0 && jQuery.queue("fx").length == 0'
  end
end
