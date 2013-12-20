require 'rubygems'
require 'sinatra'
require 'haml'
require 'mail'
require 'postmark'

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']
end

helpers do 
  def flash=(message)
    session[:flash_message] = message
  end
end
  
before do
  @submenu = request.path.split("/")[-1]
  @message = session[:flash_message]
  session[:flash_message] = nil
end

get '/' do 
  haml :'vcor/index', :layout => :'vcor/layout'
end

get '/vcor/index' do 
  haml :'vcor/index', :layout => :'vcor/layout'
end

get '/:site/directions' do 
  haml :directions, :layout => :"#{params[:site]}/layout"
end

get '/:site' do 
  if params[:site] == 'csm'
    haml :'csm/index', :layout => :'csm/layout'
  elsif params[:site] == 'vcor'
    haml :'vcor/index', :layout => :'vcor/layout'
  else
    haml :index
  end
end

get '/:site/services' do 
  haml :"#{params[:site]}/services", :layout => :"#{params[:site]}/layout"
end

get '/:site/staff' do 
  haml :"#{params[:site]}/staff", :layout => :"#{params[:site]}/layout"
end

get '/:site/patients' do 
  haml :"#{params[:site]}/patients", :layout => :"#{params[:site]}/layout"
end

get '/:site/forms' do 
  haml :"#{params[:site]}/forms", :layout => :"#{params[:site]}/layout"
end

get '/:site/render_form/:form' do 
  send_file "public/files/#{params[:form]}", :type => 'application/pdf'
end

get '/:site/faq' do 
  haml :"#{params[:site]}/faq", :layout => :"#{params[:site]}/layout"
end

get '/:site/articles/:category' do 
  haml :"#{params[:site]}/articles/#{params[:category]}", :layout => :"#{params[:site]}/layout"
end

get '/:site/contact' do
  haml :"#{params[:site]}/contact", :layout => :"#{params[:site]}/layout"
end

post '/:site/contact' do
  self.flash = "Your email has been sent!"
  redirect "#{params[:site]}/index"
end

