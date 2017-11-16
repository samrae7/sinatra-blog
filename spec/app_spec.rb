# run db purge, migrate and seed first 

ENV['RACK_ENV'] = 'test'

require File.expand_path '../app.rb', File.dirname(__FILE__)
require 'rspec'
require 'rack/test'
require 'helpers'
require 'json'
require_relative  '../db/seeds.rb'

describe 'Sinatra Blog App' do
  include Rack::Test::Methods
  include Helpers

  def app
    Sinatra::Application
  end

  it "gets all posts" do
    get '/'
    expect(last_response).to be_ok
    puts SEED_DATA[0][:title]
    expect(last_response.body).to eq(json Post.order("created_at DESC"))
  end

  it "gets a single post by id" do
    get '/posts/1'
    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)['title']).to eq(SEED_DATA[0][:title])
    expect(JSON.parse(last_response.body)['body']).to eq(SEED_DATA[0][:body])
  end
end