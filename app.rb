require 'rubygems'
require 'sinatra'
require 'haml'
##require 'pony'
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

get '/:site/articles' do 
  haml :"#{params[:site]}/articles", :layout => :"#{params[:site]}/layout"
end

get '/:site/forms' do 
  haml :"#{params[:site]}/forms", :layout => :"#{params[:site]}/layout"
end

get '/:site/render_form' do 
  send_file 'public/files/new_patient_form.pdf', :type => 'application/pdf'
end

get '/:site/services' do 
  haml :"#{params[:site]}/services", :layout => :"#{params[:site]}/layout"
end

get '/:site/staff' do 
  haml :"#{params[:site]}/staff", :layout => :"#{params[:site]}/layout"
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

