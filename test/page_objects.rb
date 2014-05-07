require 'ae_page_objects'

root_page_objects_path = File.expand_path('..', __FILE__)
$LOAD_PATH << root_page_objects_path
ActiveSupport::Dependencies.autoload_paths << root_page_objects_path

module PageObjects
  module Blank
    class Site < ::AePageObjects::Site

    end
  end
end

PageObjects::Blank::Site.initialize!