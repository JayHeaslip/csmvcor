require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do 
  haml :index
end

get '/:site/directions' do 
  haml :directions
end

get '/:site/articles' do 
  haml :"#{params[:site]}/articles", :layout => :"#{params[:site]}/layout"
end

get '/:site/forms' do 
  haml :"#{params[:site]}/forms", :layout => :"#{params[:site]}/layout"
end

get '/:site/services' do 
  haml :"#{params[:site]}/services", :layout => :"#{params[:site]}/layout"
end

get '/:site/staff' do 
  haml :"#{params[:site]}/staff", :layout => :"#{params[:site]}/layout"
end


