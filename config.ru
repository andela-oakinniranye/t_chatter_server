require 'bundler'
# require 'sinatra/base'
require 'sinatra'
require 'sinatra/reloader'
require 'json'
# require 'pry'
require './chatter_server'


run Sinatra::Application

set :bind, '0.0.0.0'

register Sinatra::Reloader
