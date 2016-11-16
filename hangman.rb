require 'sinatra'
require 'sinatra/reloader'


def initialize_defaults(difficulty)
  @@secret_word = random_word(difficulty).chars
  @@guess_count = 5
  @@word = Array.new(difficulty, "-")
  @@used = []
end

#using map to keep the words according to their counts, which helps to
#to determine the level of difficulty
def word_map
  map = {}
  #'r' is read
  file = File.open("dictionary.txt", 'r')
  file.readlines.each do |line|
    #strip is used to remove carraige return \n
    word = line.strip
    if(map.has_key?(word.length))
      map[word.length] << word
    else
      map[word.length] = [word]
    end
  end
  map
end

#generating random words according to difficulty
def random_word(difficulty)
  map = word_map()
  words = map[difficulty]
  words[rand(words.length)]
end


get '/play' do
  guess = params['guess']
  cheat = params['cheat']

  # throw params.inspect
  if(guess != nil && guess != "")
    indexes = get_guess_indexes(guess)
    update_guess_count(indexes)
    update_word(indexes, guess)
    update_used(indexes, guess)
  end

  erb :play, :locals => {
    :cheat => cheat,
    :secret_word => @@secret_word,
    :word => @@word,
    :guess_count => @@guess_count,
    :used => @@used
  }
end

get '/' do
  erb :home
end

get '/start' do
  difficulty = params['levels'].to_i
  initialize_defaults(difficulty)
  redirect to('/play')
end


#get indexes of guess in secret_word and update the respective indexes
#with the guess in update_word method
def get_guess_indexes(guess)
  idx = []
  @@secret_word.each_with_index do |c, i|
    if(c == guess)
      idx << i
    end
  end
  idx
end

def update_word(indexes, guess)
  indexes.each do |i|
    @@word[i] = guess
  end
end


#decrease the guess_count if indexes are zero indicates guess is incorrect
def update_guess_count(indexes)
  if(indexes.length == 0)
    @@guess_count -= 1
  end
end

#as you find the guess incorrect update used words
def update_used(indexes, guess)
  if(indexes.length == 0)
    @@used << guess
  end
end










