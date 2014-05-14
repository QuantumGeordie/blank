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

  def test_flash_message__error
    visit '/flash_message/error'
    home_page = PageObjects::Blank::HomePage.new
    assert_equal 'oh yeah! you just errored all over the place!', home_page.flash_error.text
    assert_equal '', home_page.flash_notice.text
    assert_equal '', home_page.flash_success.text
  end

  def test_flash_message__notice
    visit '/flash_message/notice'
    home_page = PageObjects::Blank::HomePage.new
    assert_equal 'i am here to notify you with a flash message.', home_page.flash_notice.text
    assert_equal '', home_page.flash_success.text
    assert_equal '', home_page.flash_error.text
  end

  def test_flash_message__success
    visit '/flash_message/success'
    home_page = PageObjects::Blank::HomePage.new
    assert_equal 'that was very successful.', home_page.flash_success.text
    assert_equal '', home_page.flash_notice.text
    assert_equal '', home_page.flash_error.text
  end
end