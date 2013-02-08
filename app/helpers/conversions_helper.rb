module ConversionsHelper
  def search_types
    [["English",ConversionSearch::SEARCH_ENGLISH],["Phonetic",ConversionSearch::SEARCH_PHONETIC]]
  end

  def levels
    [["Any", nil], ["None", 0]] + (1..8).map{|i| ["#{i} and above", i]}
  end
end
