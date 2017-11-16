# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require './environments'
require 'multi_json'

class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end

before do
 content_type :json
end

helpers do
  def json( dataset )
    if !dataset #.empty?
      return no_data!
    else
      JSON.pretty_generate(JSON.load(dataset.to_json)) + "\n"
    end
  end
  def no_data!
    status 204
    #json :message => “no data”
  end
end

get "/" do
  @posts = Post.order("created_at DESC")
  json @posts
end

#Get all posts
get "/posts/:id" do
 @post = Post.find(params[:id])
 json @post
end

#Get single post
post "/posts/:id" do
 @post = Post.find(params[:id])
 json @post
end

#Create
post "/posts" do
 new_post = MultiJson.load(request.body.read)
 @post = Post.new( new_post )
 if @post.save
  json @post
 else
  json @post.errors
 end
end

#Update
put "/posts/:id" do
 @post = Post.find(params[:id])
 update = MultiJson.load request.body.read
 if @post.update_attributes(update)
  json @post
 else
  json @post.errors
 end
end


