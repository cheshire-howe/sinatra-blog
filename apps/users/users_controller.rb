class UsersController < SiteController
  helpers UsersHelpers

  get "/signup/?" do
    slim :'users/signup'
  end

  post "/signup" do
    user = User.create(params[:user])
    user.password_salt = BCrypt::Engine.generate_salt
    user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
    if user.save
      flash[:info] = "Thank you for registering #{user.username}" 
      session[:user] = user.token
      redirect "/" 
    else
      flash[:error] = user.errors.full_messages
      redirect "/signup?" + hash_to_query_string(params[:user])
    end
  end

  get "/login/?" do
    if current_user
      redirect_last
    else
      slim :'users/login'
    end
  end

  post "/login" do
    if user = User.first(:email => params[:email])
      if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
      session[:user] = user.token
      response.set_cookie "user", {:value => user.token, :expires => (Time.now + 52*7*24*60*60)} if params[:remember_me]
      flash[:info] = "Successfully logged in"
      redirect_last
      else
        flash[:error] = ["Email/Password combination does not match"]
        redirect "/login?email=#{params[:email]}"
      end
    else
      flash[:error] = ["Email/Password combination does not match"]
      redirect "/login?email=#{params[:email]}"
    end
  end

  get "/logout" do
    current_user.generate_token
    response.delete_cookie "user"
    session[:user] = nil
    flash[:info] = "Successfully logged out"
    redirect "/"
  end

  get "/secret/?" do
    login_required
    slim :'users/secret'
  end

  get "/supersecret/?" do
    admin_required
    slim :'users/supersecret'
  end

  get "/thing/:slug/?" do
    is_owner? params[:slug]
    "<pre>id: #{current_user.id}\nusername: #{current_user.username}\nslug: #{current_user.slug}\nemail: #{current_user.email}\nadmin? #{current_user.admin}</pre>"
  end
end
