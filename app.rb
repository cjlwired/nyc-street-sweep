require_relative 'environment'

require 'sinatra/base'

module NycStreetSweep
  class App < Sinatra::Base

    get '/' do      
      # Define route instance variables.
      @main  = "Default - Main St"
      @from  = "Default - From St"
      @to    = "Default - To St"
      @side  = "Default - Side St"
      @text  = "Default - Text"
      @tweet = "Default - Tweet"

      @regulation_str = "Your regulation will go HERE"
      
      erb :index
    end

    post '/' do
      # Define route instance variables.
      @main  = params[:main_st]
      @from  = params[:from_st]
      @to    = params[:to_st]
      @side  = params[:side_st]
      @text  = params[:text]
      @tweet = params[:tweet]
    
      # Determine regulation based on template values.
      parse_values    = Parser.run_parsing(@main,@from,@to,@side)
      @regulation_str = "Street cleaning takes place between #{parse_values[0][0].strftime("%k:%M%p")} and #{parse_values[0][1].strftime("%k:%M%p")}\non #{parse_values[1]}"

      # Text and Tweet regulation info.
      msg = "Please move your car by #{parse_values[0][0].strftime("%k:%M%p")}! #NycStreetSweep"

      Text.send(@text,msg)
      Tweet.send(@tweet,msg)

      erb :index
    end

    # Route for index.erb updates.
    get '/test' do

      @main  = "Default - Main St"
      @from  = "Default - From St"
      @to    = "Default - To St"
      @side  = "Default - Side St"
      @text  = "Default - Text"
      @tweet = "Default - Tweet"

      @regulation_str = "Your regulation will go HERE"

      erb :test
    end

  end
end