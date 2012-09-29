begin
  if Conversion.count.zero?
    #load "#{Rails.root}/Rakefile"
    #Rake::Task['db:seed'].invoke
    system("rake db:seed >/dev/null 2>&1 &")
  end
rescue
  puts "skipping auto seed"
end
