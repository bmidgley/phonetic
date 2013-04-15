module DoubleHelper
  def double_classes(english, phonetic)
    classes = ["double"]
    classes << "changed" if english != phonetic
    classes.join(' ')
  end
end
