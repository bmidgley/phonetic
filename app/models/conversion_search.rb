class ConversionSearch 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  SEARCH_ENGLISH = 0
  SEARCH_PHONETIC = 1

  attr_accessor :query, :search_type, :page, :user_id

  validates_presence_of :search_type
  
  attr_accessor :conversions
  
  #before_validation :prepare_find
  
  def initialize(attributes = {})
    prepare_find
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def user
    @user ||= User.find @user_id
  end

  def user=(user)
    @user = user
    @user_id = user.id
  end

  def find
    
    return false unless self.valid?
    
    conditions = nil
    if search_type.to_i == SEARCH_ENGLISH
      conditions = self.format_query
    else
      conditions = self.format_query("phonetic")
    end
    
    self.conversions = Conversion.paginate :conditions => conditions, :page => self.page, :order => 'english' if self.conversions.size <= 0
  end
  
  protected
  
  def format_query(find_in = "english")

    # so we can always append conditions with 'and'
    query_list = ["1=1"]

    # filter by user
    if user
      query_list[0] = "#{query_list[0]} and user_id = ?"
      query_list << user.id
    end

    # search string
    unless self.query.blank?
      if self.query.include?("-")
        final_parameter = self.query.to_s.gsub(/-/,"%")
        query_list[0] = "#{query_list[0]} and #{find_in} like ?"
        query_list << final_parameter
      else
        query_list[0] = "#{query_list[0]} and #{find_in} = ?"
        query_list << self.query
      end
    end

    return query_list
  end
  
  def prepare_find
    self.query = self.query.to_s.strip
    self.search_type ||= SEARCH_ENGLISH
    self.conversions = []
  end

end
