class Conversion < ActiveRecord::Base
  validates_presence_of :english, :phonetic
  attr_accessible :level, :english, :phonetic
  belongs_to :user
  
  cattr_reader :per_page
  @@per_page = 150

  def self.convert(text, user, level = nil)
    level = 8 if level == 0
    user ||= User.find_by_username('anonymous') || User.find(:first, :conditions => ['is_admin = ?', ActiveRecord::Base.connection.quoted_true])
    text = text.dup
    words = text.downcase.split(" ").collect{|t| t.strip.gsub(/[^a-z| ]/,"")}.compact

    level ||= user.level
    if level
      levels = [nil] + (1..(level)).to_a
    else
      levels = [nil] + (1..8).to_a
    end

    result = self.where(:english => words, :user_id => user.dictionary_user, :level => levels)

    result.each{|t| text.gsub!(/\b#{t.english.capitalize}\b/,t.phonetic.capitalize)}
    result.each{|t| text.gsub!(/\b#{t.english}\b/,t.phonetic)}
    text
  end

  def self.import(file)
    errors = []
    File.open(file, 'r') { |f|
      while line = f.gets
        english = line[0,19].strip
        phonetic = line[19,19].gsub(/ - /,"")
        phonetic.strip!
        frequency = line[38,5].to_s.strip

        conversion = Conversion.find(:first, :conditions => ['english = ?', english])
        conversion ||= Conversion.new :english => english
        conversion.phonetic = phonetic
        conversion.frequency = frequency
        unless conversion.save
          errors << line
        end
      end
      puts "Import Finished"
      puts "Errors: #{errors.size}"
      errors.each do |t|
        puts "--- #{t}"
      end
    }
    errors
  end


end
