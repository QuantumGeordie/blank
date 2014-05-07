module PageObjects
  module Blank
    class HomePage < ::AePageObjects::Document
      path '/'

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