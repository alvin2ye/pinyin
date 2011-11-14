require 'test_helper'

class PinyinTest < Test::Unit::TestCase
  def test_full
    assert_equal("yedongkai", Pinyin.full("叶冬开"))
    assert_equal("yedongkaiyedong", Pinyin.full("叶冬开叶冬"))
    assert_equal("yedongkaiabcyedong", Pinyin.full("叶冬开abc叶冬"))
  end

  def test_abbr
    assert_equal("cjp", Pinyin.abbr("曹靖鹏"))
    assert_equal("cjpcj", Pinyin.abbr("曹靖鹏曹靖"))
    assert_equal("cjpabccj", Pinyin.abbr("曹靖鹏abc曹靖"))
  end

  def test_abbr_else
    assert_equal("caojp", Pinyin.abbr_else("曹靖鹏"))
    assert_equal("caojpcj", Pinyin.abbr_else("曹靖鹏曹靖"))
    assert_equal("caojpabccj", Pinyin.abbr_else("曹靖鹏abc曹靖"))
  end

  def test_find_etymon
    assert_equal("ye", Pinyin.find_etymon("叶"))
    assert_equal(nil, Pinyin.find_etymon("a"))
  end

  def test_size
    assert_equal 3, "叶冬开".split(//).size
  end
end
