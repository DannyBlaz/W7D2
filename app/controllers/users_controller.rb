class UsersController < ApplicationController

    def index
        @user = User.all
        render :index
    end

    def show
        @user = User.find_by(params[:id])
        render :show
    end

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            login!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = ["invalid user credentials."]
            render :new
        end
    end

    private
    def user_params
        self.params.require(:user).permit(:email, :password)
    end

end