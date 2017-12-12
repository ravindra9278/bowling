class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :get_player, :get_higest_score, :get_winner_name

  def get_player
  	User.where(id: user_ids)
  end

  def user_ids
  	game = Game.find_by_id(params[:game_id]) if params[:game_id]
  	game&.score&.keys
  end

  def get_higest_score game
  	return game.score.values.max
  end

  def get_winner_name game
  	user_id = game.score.max_by{|k,v| v}.first
  	user = User.find_by_id user_id
  	return user&.name
  end
end
