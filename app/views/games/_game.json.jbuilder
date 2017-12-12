json.extract! game, :id, :score, :player_count, :game_turn, :created_at, :updated_at
json.url game_url(game, format: :json)
