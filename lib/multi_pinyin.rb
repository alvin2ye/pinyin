class MultiPinyin < Pinyin
  M_SPLIT_CHAR = "|"

  def self.full(value, split_char = nil)
    res = etymon_mapping_arr(value, split_char)
    cross_product_arr(res).map{|w| full_word(w, split_char) }.join(M_SPLIT_CHAR)
  end

  def self.abbr(value, split_char = nil)
    res = etymon_mapping_arr(value, split_char)
    cross_product_arr(res).map{|w| abbr_word(w, split_char) }.join(M_SPLIT_CHAR)
  end

  def self.abbr_else(value, split_char = nil)
    res = etymon_mapping_arr(value, split_char)
    cross_product_arr(res).map { |w| abbr_else_word(w, split_char) }.join(M_SPLIT_CHAR)
  end

  def self.find_etymon(word)
    @@dist.select{ |k, v| v.match(word) }.map{ |k, v| k }
  end

  def self.cross_product_arr(arr)
    return arr if arr.length <= 1
    arg_str = (1..(arr.length - 1)).map{|num| "arr[#{num}]" }.join(', ')

    eval("arr[0].product(#{arg_str})")
  end

  def self.etymon_mapping_arr(value, split_char)
    return [] if value.nil?

    result = []
    value.clone.split(//).each do |w|
      etymon = find_etymon(w) if zh_cn?(w)
      result << (etymon || [w])
    end

    result
  end
end
