class TimPerryApp < Sinatra::Base
  helpers do
    def protected!
      if not authorized? then
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        if @auth.provided? && @auth.basic? && @auth.credentials
          login_as *@auth.credentials
        end
      end

      if not authorized? then
        response['WWW-Authenticate'] = %(Basic realm="Admin Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def login_as username, password
      if valid_login? username, password then
        session[:username] = username
        session[:password] = password
        session[:ever_logged_in] = true
      end
    end

    def logout
      session.delete :username
      session.delete :password
    end

    def authorized?
      valid_login? session[:username], session[:password]
    end

    def valid_login? username, password
      username == ENV["ADMIN_USERNAME"] &&
      password == ENV["ADMIN_PASSWORD"]
    end

    def ever_logged_in?
      session[:ever_logged_in]
    end
  end
end
