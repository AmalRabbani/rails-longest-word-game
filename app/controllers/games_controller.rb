require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.shuffle[0..10].join
  end

  def score
    @games = params[:games]
    @letters = params[:letters]
      if included?(@games, @letters)
        if english_word?(@games)
          @message = "Congratulations! #{@games.upcase} is a valid word!"
        else
          @message = "Sorry but #{@games.upcase} does not seem to be a valid English word!"
        end
      else
        @message = "Sorry but #{@games.upcase} can't be built out of #{@letters}"
      end
  end
  private
  def included?(games, letters)
    games.chars.all? { |letter| games.upcase.count(letter.upcase) <= letters.upcase.count(letter.upcase) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end


# pour chaque lettre de @games vérifier que la lettre apparait au moins autant de fois dans @letters
# if true alors 2 scénarios possible :
# 1) vérifier si le mot est dans le dico (cf = api) --> gagné / sinon perdu
