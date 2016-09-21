class UsersController < ApplicationController
	def index
	end
	def new
		user=User.new(user_params)
		if user.save
			session[:id] = user.id
			redirect_to '/events/'
		else
			print user.errors.full_messages
			flash[:errors]=user.errors.full_messages
			redirect_to action:'index'
		end
	end
	def login
		user=User.find_by email:params[:email]
		if user && user.authenticate(params[:password])
			session[:id] = user.id
			redirect_to '/events/'
		elsif user
			flash[:logerror]= "Your password does not match our records"
			redirect_to action:'index'
		else
			flash[:logerror]= "Email address not found"
			redirect_to action:'index'
		end
	end
	def edit
		@user = User.find(session[:id])
	end
	def update
		user = User.update(session[:id], user_params)
		if user.save
			redirect_to '/events/'
		else
			flash[:errors]=user.errors.full_messages
			redirect_to "/users/#{session[:id]}"
		end
	end
	def logout
		session[:id]=nil
		redirect_to action:'index'
	end
	private
	def user_params
		params.require(:users).permit(:first_name, :last_name, :email, :city, :state, :password, :password_confirmation)
	end
end
