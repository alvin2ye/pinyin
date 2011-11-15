require 'yaml'

$KCODE = 'u'

class Pinyin
  @@dist = YAML.load_file(File.dirname(__FILE__) + "/../dist.yml")

  def self.full(value, split_char = nil, multitone = false)
    return if value.nil?

    res = []
    value.clone.split(//).each do |w|
      etymon = find_etymon(w, multitone) if zh_cn?(w)
      res << (etymon || (multitone ? [w] : w))
    end

    if multitone
      Pinyin.cross_product_arr(res).map{|i| i.join(split_char) }.join(" ")
    else
      res.join(split_char)
    end
  end

  # TODO support multitone
  def self.abbr(value, split_char = nil)
    return if value.nil?

    value.split(//).map do |w|
      self.full(w)[0..0] # [0..0] != first in low version
    end.join(split_char)
  end

  # TODO support multitone
  def self.abbr_else(value, split_char = nil)
    return if value.nil?

    words = value.split(//)
    self.full(words.shift) + words.map do |w|
      self.full(w)[0..0]
    end.join(split_char)
  end

  def self.find_etymon(word, multitone = false)
    if multitone
      @@dist.select{ |k, v| v.match(word) }.map{ |k, v| k }
    else
      @@dist.each{ |k, v| return k if v.match(word) }
      nil
    end
  end

  def self.cross_product_arr(arr)
    return arr if arr.length <= 1
    arg_str = (1..(arr.length - 1)).map{|num| "arr[#{num}]" }.join(', ')

    eval("arr[0].product(#{arg_str})")
  end

  private

    def self.zh_cn?(w)
      w.length != 1
    end
end
