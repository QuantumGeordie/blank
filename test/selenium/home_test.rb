require File.expand_path '../../selenium_helper.rb', __FILE__

class HomeTest < SeleniumTest

  def test_home_page
    home_page = PageObjects::Blank::HomePage.visit
    assert_equal '/',                                  home_page.page_name,        'the page name'
    assert_equal 'Blank Template Sinatra Application', home_page.application_name, 'the app name'
  end

  def test_random_number
    RandomNumberGenerator.stubs(:generate_random_number).with(1000).returns(123)
    home_page = PageObjects::Blank::HomePage.visit
    assert_equal '123', home_page.random_number
  end
end