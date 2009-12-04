$KCODE = 'u'

class Pinyin
  @@dist = YAML.load_file(File.dirname(__FILE__) + "/../dist.yml")

  def self.full(value)
    ori = value
    words = ori.split(//)
    words.each do |w|
      etymon = find_etymon(w)
      ori.sub!(w, etymon) if etymon
    end
    ori
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
end
