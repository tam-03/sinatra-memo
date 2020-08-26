# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'fileutils'
enable :method_override

before do
  @memo = Dir.glob("*").grep(/.txt/).map do |t| t end
end

get '/' do
  erb :index
end

get '/create' do
  erb :create
end

post '/create' do
    @memo_title = params[:memo_title]
    @memo_content = params[:memo_content]
    File.open("#{@memo_title}.txt", "w") do |f|
      f.puts("#{@memo_title},#{@memo_content}")
    end
    erb :save
end

get '/show-:txt_name' do |t|
    @txt_name = t
  erb :show
end

delete '/show-:txt_name' do |t|
  File.delete("#{t}")
  redirect to('/')
end

get '/edit-:txt_name' do |t|
  @txt_name = t
    File.open("#{t}", "r") do |f|
        @memo_date = f.read.split(",")
    end
  erb :edit
end

patch '/edit-:txt_name' do |t|
  @txt_name = t
  File.open("#{@txt_name}", "w") do |f|
    f.puts("#{params[:edit_title]},#{params[:edit_content]}")
  end
  File.rename("#{@txt_name}", "#{params[:edit_title]}.txt")
  redirect to('/')
end

