require 'yaml'

$KCODE = 'u'

class Pinyin
  @@dist = YAML.load_file(File.dirname(__FILE__) + "/../dist.yml")

  def self.full(value, split_char = nil)
    res = etymon_mapping_arr(value, split_char)
    full_word(res, split_char)
  end

  def self.abbr(value, split_char = nil)
    res = etymon_mapping_arr(value, split_char)
    abbr_word(res, split_char)
  end

  def self.abbr_else(value, split_char = nil)
    res = etymon_mapping_arr(value, split_char)
    abbr_else_word(res, split_char)
  end

  def self.find_etymon(word)
    @@dist.each{ |k, v| return k if v.match(word) }
    nil
  end

  def self.zh_cn?(w)
    w.length != 1
  end

  def self.etymon_mapping_arr(value, split_char)
    return [] if value.nil?

    result = []
    value.clone.split(//).each do |w|
      etymon = find_etymon(w) if zh_cn?(w)
      result << (etymon || w)
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
