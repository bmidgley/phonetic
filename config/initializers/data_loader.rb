begin
  if User.count.zero?
    load "#{Rails.root}/Rakefile"
    Rake::Task['db:seed'].invoke
  end
rescue
  puts "skipping auto seed"
end
