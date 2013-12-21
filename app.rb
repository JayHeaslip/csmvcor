require 'rubygems'
require 'sinatra'
require 'haml'
require 'mail'

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']
  Mail.defaults do
    delivery_method :smtp, {
      address: 'smtp.sendgrid.net',
      port: 587,
      domain: 'heroku.com',
      user_name: ENV['SENDGRID_USERNAME'],
      password: ENV['SENDGRID_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end
end

helpers do 
  def flash=(message)
    session[:flash_message] = message
  end

  def flash_error=(message)
    session[:flash_error] = message
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end
  
before do
  @submenu = request.path.split("/")[-1]
  @message = session[:flash_message]
  @error_message = session[:flash_error]
  session[:flash_message] = nil
  session[:flash_error] = nil
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
  from =  "#{h(params[:name])} <#{params[:email]}>"
  subject = h(params[:subject])
  body = h(params[:body])

  begin
    Mail.deliver do
      from           from
      to             'VCOR <jheaslip@comcast.net>'
      subject        subject
      body           body
    end
    self.flash = "Your email has been sent!"
    redirect "#{params[:site]}/index"
  rescue
    self.flash_error = "There was a problem sending your email, please try again."
      haml :'vcor/contact', :layout => :'vcor/layout'
  end

end

