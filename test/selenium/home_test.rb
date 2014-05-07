require File.expand_path '../../selenium_helper.rb', __FILE__

class HomeTest < SeleniumTest

  def test_home_page
    home_page = PageObjects::Blank::HomePage.visit
    assert_equal 'This is the Blank.Template',         home_page.page_name,        'the page name'
    assert_equal 'Blank Template Sinatra Application', home_page.application_name, 'the app name'
  end
end