# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'fileutils'
require 'pg'
enable :method_override

before do
  @connection = PG::connect(:host => "localhost", :dbname => "memoapp", :port => "5432")
end

get '/memo' do
  @memo_titles = @connection.exec("SELECT title from memo;")
  erb :index
end

get '/memo/new' do
  erb :create
end

post '/memo' do
  @memo_title = params[:memo_title]
  @memo_body = params[:memo_body]
  @new_memo = @connection.exec("insert into memo (title, body) values ($1,$2)",[@memo_title, @memo_body])
  erb :save
end

get '/memo/:memo_title' do |memo_title|
  @single_memo = @connection.exec("SELECT title, body from memo where title = $1",[memo_title])
  erb :show
end

delete '/memo/:memo_title' do |memo_title|
  @connection.exec("DELETE from memo where title = $1",[memo_title])
  redirect to('/memo')
end

get '/memo/custom/:memo_title' do |memo_title|
  @result = @connection.exec("SELECT title, body from memo where title = $1",[memo_title])
  erb :edit
end

patch '/memo/:memo_title' do |memo_title|
  edit_title = params[:edit_title]
  edit_body = params[:edit_body]
  @edit_memo = @connection.exec("update memo set title = $1, body = $2 where title = $3",[edit_title, edit_body, memo_title])
  redirect to('/memo')
end
