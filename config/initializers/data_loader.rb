if Conversion.count.zero?
  load "#{Rails.root}/Rakefile"
  Rake::Task['db:seed'].invoke
end

