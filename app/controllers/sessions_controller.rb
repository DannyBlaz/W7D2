class SessionsController < ApplicationController

    def new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
        if @user
            # login re-set the appropriate user's session_token and session[:session_token].
            login!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = ["invalid credentials."]
            render :new
        end
    end

    def destroy
        logout!
        flash[:success] = ["Successfully logged out."]
        redirect_to new_session_url
    end

end