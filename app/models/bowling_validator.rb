class BowlingValidator < ActiveModel::Validator
  def validate(record)
  	record.errors.add(:base, "Invalid try entries") if (record.try1 + record.try2) > 10	
  	record.errors.add(:base, "Strike case second try should be zero") if check_stike_maker record
  	record.errors.add(:base, "Invalid turn Please check player turn from Dashboard") if validate_frame_with_turn record
  end

  private
  	def validate_frame_with_turn record
  	  return true if record.turn_number == record.game.game_turn
  	  frame = Frame.find_by_turn_number_and_user_id_and_game_id(record.turn_number-1, record.user_id, record.game_id)
  	  return true if frame.blank? && record.turn_number > 1
  	  return false
  	end

    def check_stike_maker record
       return true if (record.try1 == 10 && record.try2 > 0) || (record.try2 == 10 && record.try1 > 0)
    end
end