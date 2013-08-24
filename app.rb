require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do 
  haml :index
end

get '*/directions' do 
  haml :directions
end

get '/:site/services' do 
  haml :"#{params[:site]}/services", :layout => :"#{params[:site]}/layout"
end

##get 'csm/forms' do 
##  haml :forms
##end
##
##get 'vcor/services' do 
##  haml :vcorservices
##end
##
##get 'vcor/articles' do 
##  haml :vcorarticles
##end
##
##get 'vcor/staff' do 
##  haml :staff
##end
##
##get 'vcor/forms' do 
##  haml :forms
##end



