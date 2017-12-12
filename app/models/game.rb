class Game < ApplicationRecord
  serialize :score
  
  attr_accessor :player_lists

  has_many :frames

  after_initialize :set_initial_value, :if => :new_record?

  validates :player_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }

  # Initalize value for score and game_turn
  # Here adding players to game
  # It would be an array of players
  def set_initial_value
  	self.game_turn = 0
  	self.score = {}
  	player_lists&.reject!(&:empty?)&.each do |player|
  	  self.score[player.to_i] = 0
  	end
  	self.player_count = player_lists&.size
  end
end




# ******** Game table schema ********
=begin
  create_table "games", force: :cascade do |t|
    t.text "score"
    t.integer "player_count"
    t.integer "game_turn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
=end