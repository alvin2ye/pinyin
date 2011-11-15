require 'yaml'

$KCODE = 'u'

class Pinyin
  @@dist = YAML.load_file(File.dirname(__FILE__) + "/../dist.yml")

  def self.full(value, split_char = nil)
    return if value.nil?

    value.clone.split(//).map do |w|
      etymon = find_etymon(w) if zh_cn?(w)
      etymon ||= w
    end.join(split_char)
  end

  def self.abbr(value, split_char = nil)
    return if value.nil?

    value.split(//).map do |w|
      self.full(w)[0..0] # [0..0] != first in low version
    end.join(split_char)
  end

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

  private

    def self.zh_cn?(w)
      w.length != 1
    end
end
