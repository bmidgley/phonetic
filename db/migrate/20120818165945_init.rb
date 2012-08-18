class Init < ActiveRecord::Migration
def up
  create_table "bookmarks", :force => true do |t|
    t.text      "name"
    t.integer   "page_number"
    t.integer   "book_id"
    t.integer   "user_id"
    t.integer   "start"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "books", :force => true do |t|
    t.string    "name"
    t.string    "author"
    t.string    "url"
    t.integer   "size"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "user_id"
  end

  create_table "conversions", :force => true do |t|
    t.integer   "level"
    t.string    "english"
    t.string    "phonetic"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "frequency",    :limit => 11
    t.integer   "private_list",               :default => 0
  end

  create_table "samples", :force => true do |t|
    t.text      "english"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "session_id"
  end

  create_table "users", :force => true do |t|
    t.string    "username"
    t.string    "email"
    t.string    "crypted_password"
    t.string    "password_salt"
    t.string    "persistence_token"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "is_admin",           :default => false
    t.boolean   "is_editor",          :default => false
    t.integer   "dictionary_user_id"
  end
end

def down
  drop_table "users"
  drop_table "samples"
  drop_table "conversions"
  drop_table "books"
  drop_table "bookmarks"
end

end
