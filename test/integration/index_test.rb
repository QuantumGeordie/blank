require File.expand_path '../../test_helper.rb', __FILE__

class IndexTest < IntegrationTest

 def test_hello_world
    get '/'
    assert last_response.ok?
  end

end