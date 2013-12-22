require 'rubygems'
require 'sinatra'
require 'haml'
require 'mail'
require 'logger'
require 'resolv'
require 'newrelic_rpm'

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']

  LOG = Logger.new(STDOUT)
  LOG.level = Logger::INFO

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
  def flash_info=(message)
    session[:flash_info] = message
  end

  def flash_error=(message)
    session[:flash_error] = message
  end

  def validate(params)
    errors = {}
    
    [:name, :email, :subect, :message].each{|key| params[key] = (params[key] || "").strip }

    errors[:name]    = "This field is required" unless given? params[:name]

    if given? params[:email]
      errors[:email]   = "Please enter a valid email address" unless valid_email? params[:email]
    else
      errors[:email]   = "This field is required"
    end

    errors[:subject] = "This field is required" unless given? params[:subject]
    
    errors[:message] = "This field is required" unless given? params[:message]

    errors
  end

  def valid_email?(email)
    if email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
      domain = email.match(/\@(.+)/)[1]
      Resolv::DNS.open do |dns|
        @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      end
      @mx.size > 0 ? true : false
    else
      false
    end
  end

  def given? field
    !field.empty?
  end

end
  
before do
  @submenu = request.path.split("/")[-1]
  @flash_info  = session[:flash_info]
  @flash_error = session[:flash_error]
  session[:flash_info] = nil
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
  @errors = {}
  haml :"#{params[:site]}/contact", :layout => :"#{params[:site]}/layout"
end

post '/:site/contact' do
  @errors = validate(params)

  @name = params[:name]
  @email = params[:email]
  @subject = params[:subject]
  @message = params[:message]

  if @errors.empty?
    from =  "#@name <#@email>"
    subject = @subject
    body = @message
    begin
      Mail.deliver do
        from           from
        to             'VCOR <jheaslip@comcast.net>'
        subject        subject
        body           body
      end
      self.flash_info = "Your email has been sent!"
    rescue Exception => e
      puts e.message
      LOG.error e.message
      LOG.error e.backtrace.join('/n')
      self.flash_error = "There was a problem sending your email, please try again later."
    end  
    redirect "#{params[:site]}/index"
  else
    haml :'vcor/contact', :layout => :'vcor/layout'
  end
end

