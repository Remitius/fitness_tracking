require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "universal header and footer" do
    get new_path
    assert_select 'a[href="/"]', count: 1
  end

  test "link to root path not present in root path's header" do
    get root_path
    assert_select 'a[href="/"]', count: 0
  end

end
