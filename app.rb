# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'fileutils'
enable :method_override

before do
  @memo = Dir.glob('*').grep(/.txt/).map { |t| t }
end

get '/memo' do
  erb :index
end

get '/memo/new' do
  erb :create
end

post '/memo/new' do
  @memo_title = params[:memo_title]
  @memo_content = params[:memo_content]
  @memo.map do |f|
    txt_name = f.gsub(/\.txt/, "")
    if txt_name == @memo_title
      redirect to('/memo/new')
    else
      File.open("#{@memo_title}.txt", 'w') do |f|
        f.puts("#{@memo_title},#{@memo_content}")
      end
    end
  end
  erb :save
end

get '/memo/:txt_name' do |t|
  @txt_name = t
  File.open("#{@txt_name}", "r") do |f|
    @memo_date = f.read.split(",")
  end
  erb :show
end

delete '/memo/:txt_name' do |t|
  File.delete(t.to_s)
  redirect to('/memo')
end

get '/memo/custom/:txt_name' do |t|
  @txt_name = t
  File.open("#{@txt_name}", "r") do |f|
    @memo_date = f.read.split(',')
  end
  erb :edit
end

patch '/memo/custom/:txt_name' do |t|
  @txt_name = t
  File.open(@txt_name.to_s, 'w') do |f|
    f.puts("#{params[:edit_title]},#{params[:edit_content]}")
  end
  File.rename(@txt_name.to_s, "#{params[:edit_title]}.txt")
  redirect to('/memo')
end
