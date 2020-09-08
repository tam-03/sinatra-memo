# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'fileutils'
require 'pg'
enable :method_override

before do
  @connection = PG::connect(:host => "localhost", :user => "tamuratakumi", :password => "takumi", :dbname => "memoapp", :port => "5432")
end

get '/memo' do
  @result = @connection.exec("SELECT title from memo;")
  erb :index
end

get '/memo/new' do
  erb :create
end

post '/memo' do
  @memo_title = params[:memo_title]
  @memo_content = params[:memo_content]
  @memo << "#{@memo_title}.txt"
  if @memo.count("#{@memo_title}.txt") == 1
    File.open("#{@memo_title}.txt", 'w') do |f|
      f.puts("#{@memo_title},#{@memo_content}")
    end
    erb :save
  else
    redirect to('/memo/new')
  end
end

get '/memo/:txt_name' do |t|
  @txt_name = t
  File.open(@txt_name.to_s, 'r') do |f|
    @memo_data = f.read.split(',')
  end
  erb :show
end

delete '/memo/:txt_name' do |t|
  File.delete(t.to_s)
  redirect to('/memo')
end

get '/memo/custom/:txt_name' do |t|
  @txt_name = t
  File.open(@txt_name.to_s, 'r') do |f|
    @memo_data = f.read.split(',')
  end
  erb :edit
end

patch '/memo/:txt_name' do |t|
  @txt_name = t
  File.open(@txt_name.to_s, 'w') do |f|
    f.puts("#{params[:edit_title]},#{params[:edit_content]}")
  end
  File.rename(@txt_name.to_s, "#{params[:edit_title]}.txt")
  redirect to('/memo')
end
