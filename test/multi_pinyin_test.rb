require 'test_helper'

class MultiPinyinTest < Test::Unit::TestCase
  def test_full
    assert_equal "yedongkai|xiedongkai", MultiPinyin.full("叶冬开")
    assert_equal "yedongkaiabcyedong|yedongkaiabcxiedong|xiedongkaiabcyedong|xiedongkaiabcxiedong", MultiPinyin.full("叶冬开abc叶冬", nil)
  end

  def test_abbr
    assert_equal "gjp|hjp", MultiPinyin.abbr("红靖鹏")
  end

  def test_abbr_else
    assert_equal "gongyjp|gongxjp|hongyjp|hongxjp", MultiPinyin.abbr_else("红叶靖鹏")
  end

  def test_find_etymon
    assert_equal ["ye", "xie"], MultiPinyin.find_etymon("叶")
  end

  def test_cross_product_arr
    assert_equal [["a", 1], ["a", 2], ["a", 3], ["b", 1], ["b", 2], ["b", 3]], MultiPinyin.cross_product_arr([['a', 'b'], [1, 2, 3]])
  end
end
