#!/usr/bin/env ruby
# INSERT INTO conversions (id, level, english, phonetic, user_id, created_at, updated_at, frequency, private_list) VALUES (1, NULL, 'of', 'ov', 3, '2010-06-16 22:11:59', '2011-02-18 01:04:17', '35844', 0);

ARGF.each do |line|
  next unless line =~ /VALUES \(\d*, (.*)\);/
  puts "INSERT INTO conversions (level, english, phonetic, user_id, created_at, updated_at, frequency, private_list) VALUES (#{$1});"
end
