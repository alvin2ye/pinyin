require 'yaml'

$KCODE = 'u'

class Pinyin
  @@dist = YAML.load_file(File.dirname(__FILE__) + "/../dist.yml")

  def self.full(value, split_char = nil, multitone = false)
    res = etymon_mapping_arr(value, split_char, multitone)

    if multitone
      Pinyin.cross_product_arr(res).map{|w| full_word(w, split_char) }.join("|")
    else
      full_word(res, split_char)
    end
  end

  def self.abbr(value, split_char = nil, multitone = false)
    res = etymon_mapping_arr(value, split_char, multitone)

    if multitone
      Pinyin.cross_product_arr(res).map{|w| abbr_word(w, split_char) }.join("|")
    else
      abbr_word(res, split_char)
    end
  end

  def self.abbr_else(value, split_char = nil, multitone = false)
    res = etymon_mapping_arr(value, split_char, multitone)

    if multitone
      Pinyin.cross_product_arr(res).map { |w| abbr_else_word(w, split_char) }.join("|")
    else
      abbr_else_word(res, split_char)
    end
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

    def self.etymon_mapping_arr(value, split_char, multitone)
      return [] if value.nil?

      result = []
      value.clone.split(//).each do |w|
        etymon = find_etymon(w, multitone) if zh_cn?(w)
        result << (etymon || (multitone ? [w] : w))
      end

      result
    end

    def self.full_word(word, split_char)
      Proc.new { word.join(split_char) }.call
    end

    def self.abbr_word(word, split_char)
      Proc.new { word.map{|i| i[0..0]}.join(split_char) }.call
    end

    def self.abbr_else_word(word, split_char)
      Proc.new do
        i_index = 0
        word.map do |w|
          i_index += 1
          i_index == 1 ? w : w[0..0]
        end.join(split_char)
      end.call
    end
end
