class User < ApplicationRecord
	has_many :frames

	validates :name, presence: true, allow_blank: false
	validates :email, uniqueness: true, presence: true, allow_blank: false

	
end




# ******** User table schema ********
=begin
  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
=end