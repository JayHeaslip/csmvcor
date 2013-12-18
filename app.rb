require 'rubygems'
require 'sinatra'
require 'haml'
require 'pp'
##require 'sinatra/base'
##require 'rack-flash'

##class MyApp < Sinatra::Base

enable :sessions
##use Rack::Flash

set :prawn, { :page_layout => :landscape }

get '/' do 
  haml :'vcor/index', :layout => :'vcor/layout'
end

get '/vcor/index' do 
  @submenu = "index"
  haml :'vcor/index', :layout => :'vcor/layout'
end

get '/:site/directions' do 
  @submenu = "directions"
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

get '/:site/articles' do 
  @submenu = "articles"
  haml :"#{params[:site]}/articles", :layout => :"#{params[:site]}/layout"
end

get '/:site/patients' do 
  @submenu = "patients"
  haml :"#{params[:site]}/patients", :layout => :"#{params[:site]}/layout"
end

get '/:site/forms' do 
  haml :"#{params[:site]}/forms", :layout => :"#{params[:site]}/layout"
end

get '/:site/render_form/:form' do 
  send_file "public/files/#{params[:form]}", :type => 'application/pdf'
end

get '/:site/services' do 
  @submenu = "services"
  haml :"#{params[:site]}/services", :layout => :"#{params[:site]}/layout"
end

get '/:site/staff' do 
  @submenu = "staff"
  haml :"#{params[:site]}/staff", :layout => :"#{params[:site]}/layout"
end

get '/:site/faq' do 
  @submenu = "faq"
  haml :"#{params[:site]}/faq", :layout => :"#{params[:site]}/layout"
end

get '/:site/contact' do
  haml :"#{params[:site]}/contact", :layout => :"#{params[:site]}/layout"
end

post '/:site/contact' do
  name = params[:name]
  mail = params[:mail]
  subject = params[:subject]
  body = params[:body]     
  Pony.mail(:to => 'jayheaslip@gmail.com', 
            :from => mail, 
            :subject => subject, 
            :body => body,
            :via => :smtp,
            :via_options => { 
              :address              => 'smtp.gmail.com', 
              :port                 => '587', 
              :enable_starttls_auto => true, 
              :user_name            => 'jayheaslip', 
              :password             => '--------',
              :authentication       => :plain, 
              :domain               => 'localhost.localdomain'
            }
            )
  flash[:notice] = "Email was sent."
  redirect "#{params[:site]}/index"
end

