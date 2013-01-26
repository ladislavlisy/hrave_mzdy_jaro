Given /^I am on "([^"]*)"$/ do |page_name|
  FactoryGirl.create(:periodJan2013)
  visit "/"
end

When /^I follow "([^"]*)"$/ do |link_label|
  click_link link_label
end

Then /^I should see title "([^"]*)"$/ do |title_text|
  within('head title') do
    page.should have_content(title_text)
  end
end

When /^I select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select value, :from => field
end

When /^I fill im "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in field, :with => value
end

When /^I submit "([^"]*)"$/ do |button_label|
  click_button(button_label)
end