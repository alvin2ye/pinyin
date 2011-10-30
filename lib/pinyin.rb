$KCODE = 'u'

class Pinyin
  @@dist = YAML.load_file(File.dirname(__FILE__) + "/../dist.yml")

  def self.full(value)
    words = value.to_s.split(//)
    words.map do |w|
      etymon = find_etymon(w) if zh_cn?(w)
      etymon || w
    end.join
  end

  def self.find_etymon(word)
    etymon = nil
    @@dist.each  do |k, v|
      if v.match(word)
        etymon = k and break
      end
    end

    etymon
  end

  private

    def zh_cn?(w)
      w.length != 1
    end
end
