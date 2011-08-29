Given /^I am viewing "([^"]*)"$/ do |arg1|
  visit(arg1)
end

Then /^I should see "([^"]*)"$/ do |arg1|
  response_body.should =~ Regexp.new(Regexp.escape(arg1))
end

