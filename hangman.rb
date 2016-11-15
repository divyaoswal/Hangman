require 'sinatra'
require 'sinatra/reloader'


def initialize_defaults(difficulty)
  @@secret_word = random_word(difficulty).chars
  # @@secret_word = (0...@@difficulty).map{ random_char() }
  @@guess_count = 5
  @@word = Array.new(difficulty, "-")
  @@misses = []
end


def word_map
  map = {}
  file = File.open("dictionary.txt", 'r')
  file.readlines.each do |line|
    word = line.strip
    if(map.has_key?(word.length))
      map[word.length] << word
    else
      map[word.length] = [word]
    end
  end
  map
end

def random_word(difficulty)
  map = word_map()
  words = map[difficulty]
  words[rand(words.length)]
end


get '/play' do
  guess = params['guess']
  cheat = params['cheat']
  if(cheat == 'true')
    secret = @@secret_word
  end

  # throw params.inspect
  if(guess != nil && guess != "")
    indexes = get_guess_indexes(guess)
    update_guess_count(indexes)
    update_word(indexes, guess)
    update_used(indexes, guess)
  end

  erb :play, :locals => {
    :secret => secret,
    :secret_word => @@secret_word,
    :word => @@word,
    :guess_count => @@guess_count,
    :misses => @@misses
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

get '/restart' do
  redirect to('/')
end

def get_guess_indexes(guess)
  idx = []
  @@secret_word.each_with_index do |c, i|
    if(c == guess)
      idx << i
    end
  end
  idx
end

def update_guess_count(indexes)
  if(indexes.length == 0)
    @@guess_count -= 1
  end
end

def update_misses(indexes, guess)
  if(indexes.length == 0)
    @@misses << guess
  end
end

def update_word(indexes, guess)
  indexes.each do |i|
    @@word[i] = guess
  end
end








