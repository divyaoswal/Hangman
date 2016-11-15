require 'sinatra'
require 'sinatra/reloader'

def random_char
  (97 + (rand(26))).chr
end

@@difficulty = 5

def initialize_defaults()
  @@secret_word = (0...@@difficulty).map{ random_char() }
  @@guess_count = 5
  @@word = Array.new(@@difficulty, "-")
  @@misses = []
end

initialize_defaults()

get '/' do
  guess = params['guess']
  if(guess != nil)
    indexes = get_guess_indexes(guess)
    update_guess_count(indexes)
    update_word(indexes, guess)
    update_misses(indexes, guess)
  end

  erb :index, :locals => {
    :secret_word => @@secret_word,
    :word => @@word,
    :guess_count => @@guess_count,
    :misses => @@misses
  }
end

get '/restart' do
  initialize_defaults()
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






