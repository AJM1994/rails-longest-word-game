require 'json'
require 'open-uri'
class GamesController < ApplicationController
  def new
    # used to display a new random grid and a form
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
    @letters.shuffle!
  end
  # def score
  #   # used to submit the form (via POST)
  #   @answer = params[:answer]
  #   while @answer.each_char.map { |answer| @letters.include?(answer) }
  #     # answer == letters .. the word is valid to the letters but not an enligh word
  #     # the world is valid to the grid and is an english word - use dictonary link
  #     url = ("https://wagon-dictionary.herokuapp.com/#{@answer}")
  #     response = URI.open(url).read
  #     data = JSON.parse(response)
  #     # raise
  #     if data.keys[0].true?
  #       @answer = "Congratulations #{@answer} is a valid English word!"
  #     else
  #       @answer = "Sorry but #{@answer} does not seem to be a valid English word."
  #     end
  #   end
  #   # the letters dont match the grid
  # end
  def score
    # used to submit the form (via POST)
    @answer = params[:answer]
    while included?(@answer, @letters)
      if valid_word?(@answer, @letters)
        @score = "Congratulations #{@answer} is a valid English word!"
      else
        @score = "Sorry but #{@answer} does not seem to be a valid English word."
      end
    end
    @score = "Sorry but #{@answer} can't be built out of #{@letters}"
  end

  private

  def valid_word?(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    response = URI.open(url).read
    data = JSON.parse(response)
    data["found"]
  end

  def included?(answer, letters)
    answer.chars.all? { |letter| answer.count(letter) <= letters.count(letter) }
  end
end


# require 'json'
# require 'open-uri'
# class GamesController < ApplicationController
#   def new
#     @grid = generate_grid
#     @start_time = Time.now
#   end
#   def score
#     @answer = params[:input]
#     grid = params[:grid]
#     start_time = Time.parse(params[:start_time])
#     end_time = Time.now
#     @result = run_game(@answer, grid, start_time, end_time)
#   end
#   private
#   def generate_grid
#     (0..10).map { ('A'..'Z').to_a[rand(26)] }.join
#   end
#   def included?(answer, grid)
#     answer.split('').all? { |letter| grid.include? letter }
#   end
#   def compute_score(attempt, time_taken)
#     time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
#   end
#   def run_game(attempt, grid, start_time, end_time)
#     result = { time: end_time - start_time }
#     score_and_message = score_and_message(attempt, grid, result[:time])
#     result[:score] = score_and_message.first
#     result[:message] = score_and_message.last
#     result
#   end
#   def score_and_message(attempt, grid, time)
#     if included?(attempt.upcase, grid)
#       if english_word?(attempt)
#         score = compute_score(attempt, time)
#         [score, "well done"]
#       else
#         [0, "not an english word"]
#       end
#     else
#       [0, "not in the grid"]
#     end
#   end
#   def english_word?(word)
#     response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
#     json = JSON.parse(response.read)
#     json['found']
#   end
# end
