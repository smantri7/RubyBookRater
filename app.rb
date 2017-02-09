require 'sinatra'
require 'yaml/store'
require 'sinatra/activerecord'
require './config/environments'
require './models/model'

get '/' do
	@title = 'Welcome to the Book Rater'
	erb :index
end

Choices = {
'R' => "Romance",
'A' => "Action",
'H' => "Historical",
'M' => "Mystery",
'Ho' => "Horror",
'O' => "Other",
}

post '/cast' do 
	@title = 'Thanks for casting your vote!'
  	@vote  = params['vote']
  	@store = YAML::Store.new 'votes.yml'
  	@store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end

get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end

post '/submit' do
  @model = Model.new(params[:model])
  if @model.save
    redirect '/models'
  else
    "Sorry, there was an error!"
  end
end

get '/models' do
  @models = Model.all
  erb :models
end