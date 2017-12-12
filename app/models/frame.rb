class Frame < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :game
  
  validates :turn_number , :numericality => { :only_integer => true, :greater_than => 0, :less_than_or_equal_to => 10}, :presence => true
  validates_uniqueness_of :turn_number, scope: [:user_id, :game_id]

  validates :try1 , :numericality => { :only_integer => true, :less_than_or_equal_to => 10,  :greater_than_or_equal_to => 0 }, :presence => true
  validates :try2 , :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :greater_than_or_equal_to => 0}, :presence => true

  validates_with BowlingValidator, fields: [:try1, :try2, :turn_number, :game_turn]

  before_save :set_status
  before_save :score_logic
  after_save :set_turn

  private
    def set_status
      self.score = self.try1 + self.try2
      return self.status = "strike"  if (score == 10) && (self.try1.zero? || self.try2.zero?)
      return self.status = "spare" if score == 10
      return self.status = "none"
    end

    def set_turn
      frame_obj = Frame.where("turn_number=? and game_id =?", self.game.game_turn+1, self.game_id)
      if(self.game.game_turn != 10 && frame_obj.count == self.game.player_count)
        self.game.game_turn += 1
        self.game.save!
      end
    end

    # TODO FIXME
    # Main Game logic
    def score_logic
      total_score = frame_score if self.game
      if (self.turn_number > 1 && self.turn_number <= 10)
        latest_frame = Frame.find_by_turn_number_and_user_id_and_game_id!(self.turn_number-1, self.user_id, self.game_id)
        if (latest_frame.status == "strike")
          latest_frame.update_column(:score, latest_frame.score + self.score)
          total_score += self.score
        elsif (latest_frame.status == "spare")
          latest_frame.update_column(:score, latest_frame.score + self.try1)
          total_score += self.try1
        else
          total_score = total_score
        end
        self.game.score.merge!(self.user_id => total_score)
      else
        self.game.score.merge!(self.user_id => total_score)
      end
      self.game.save!
    end

    def frame_score
      return self.score + self.game.score[self.user_id]
    end  
end




# ******** Frame table schema ********
=begin
  create_table "frames", force: :cascade do |t|
    t.integer "try1"
    t.integer "try2"
    t.integer "turn_number"
    t.string "status"
    t.integer "user_id"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_frames_on_game_id"
    t.index ["user_id"], name: "index_frames_on_user_id"
  end
=end