module PageObjects
  module Blank
    class HomePage < ::AePageObjects::Document
      path '/'

      element :flash_notice,  :locator => '.flash_notice'
      element :flash_error,   :locator => '.flash_error'
      element :flash_success, :locator => '.flash_success'

      def application_name
        node.find('#js-application_name').text
      end

      def page_name
        node.find('#js-page_name').text
      end

      def random_number
        node.find('#js-random_number').text
      end
    end
  end
end