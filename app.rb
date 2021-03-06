require("bundler/setup")
Bundler.require(:default)
require 'pry'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file}

get '/' do
  @words = Word.all
  erb(:index)
end

post '/words' do
  word = params.fetch("word")
  Word.create({:word => word })
  redirect '/'
end

delete '/' do
  @words = Word.all
  @words.each do |word|
    word.delete
  end
  @guesses = Guess.all
  @guesses.each do |guess|
    guess.delete
  end
  redirect '/'
end

get '/gallows/:id' do
  word_id = params.fetch('id').to_i
  @word = Word.find(word_id)
  @guesses= Guess.all()
  erb(:gallows)
end

post '/gallows/:id' do
  guess = params.fetch("guess")
  word_id = params.fetch("id").to_i
  guesses = Guess.all
  @guess = Guess.create(guess: guess, word_id: word_id)
  @word = Word.find(word_id)
  if @word.word.include?(@guess.guess) || @guess.save.eql?(false)
    @guess.update(included: true)
    if @word.win?
      redirect("/win/#{@word.id}")
    else
      redirect("/gallows/#{@word.id}")
    end
  else
    @guess.update(included: false)
    redirect("/heads/#{@word.id}")
  end
end

get '/heads/:id' do
  @guesses= Guess.all()
  word_id = params.fetch("id").to_i
  @word = Word.find(word_id)
  @not_included = Guess.not_included()

  erb(:head)
end

post'/heads/:id' do
  guess = params.fetch("guess")
  word_id = params.fetch("id").to_i
  @guess = Guess.create(guess: guess, word_id: word_id)
  @word = Word.find(word_id)
  if @word.word.include?(@guess.guess) || @guess.save.eql?(false)
    @guess.update(included: true)
    if @word.win?
      redirect("/win/#{@word.id}")
    else
      redirect("/heads/#{@word.id}")
    end
  else
    @guess.update(included: false)
    redirect("/body/#{@word.id}")
  end
end

get '/body/:id' do
  @guesses= Guess.all()
  word_id = params.fetch("id").to_i
  @word = Word.find(word_id)
  @not_included = Guess.not_included()
  erb(:body)
end


post '/body/:id' do
  guess = params.fetch("guess")
  word_id = params.fetch("id").to_i
  @guess = Guess.create(guess: guess, word_id: word_id)
  @word = Word.find(word_id)
  if @word.word.include?(@guess.guess) || @guess.save.eql?(false)
    @guess.update(included: true)
    if @word.win?
      redirect("/win/#{@word.id}")
    else
      redirect("/body/#{@word.id}")
    end
  else
    @guess.update(included: false)
    redirect("/arms/#{@word.id}")
  end
end

get '/arms/:id' do
  @guesses= Guess.all()
  word_id = params.fetch("id").to_i
  @word = Word.find(word_id)
  @not_included = Guess.not_included()
  erb(:arms)
end

post'/arms/:id' do
  guess = params.fetch("guess")
  word_id = params.fetch("id").to_i
  @guess = Guess.create(guess: guess, word_id: word_id)
  @word = Word.find(word_id)
  if @word.word.include?(@guess.guess) || @guess.save.eql?(false)
    @guess.update(included: true)
    if @word.win?
      redirect("/win/#{@word.id}")
    else
      redirect("/arms/#{@word.id}")
    end
  else
    @guess.update(included: false)
    redirect("/legs/#{@word.id}")
  end
end

get '/legs/:id' do
  word_id = params.fetch("id").to_i
  @word = Word.find(word_id)
  @guesses = Guess.all
  @guesses.each do |guess|
    guess.delete
  end
  erb(:legs)
end

get '/win/:id' do
  word_id = params.fetch("id").to_i
  @word = Word.find(word_id)
  @guesses = Guess.all
  @guesses.each do |guess|
    guess.delete
  end
  erb(:win)
end
