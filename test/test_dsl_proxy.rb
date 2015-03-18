require 'helper'

class TestDSLProxy < MiniTest::Test
  include Sheaf

  def test_apply
    ret = DSLProxy.apply("foobar".freeze) do
      reverse
      upcase
    end

    assert_equal "RABOOF", ret
    refute_kind_of DSLProxy, ret
  end
end

