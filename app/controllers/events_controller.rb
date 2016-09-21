class EventsController < ApplicationController
	def index
		@user=User.find(session[:id])
		@events_in_state=Event.where("state=?", @user.state).limit(5)
		@events_out_of_state=Event.where("state!=?", @user.state).limit(3)
	end
	def destroy
		Event.find(params[:id]).destroy
		redirect_to '/events/'
	end
	def cancel
		attendance=Attendance.find_by user:session[:id], event: params[:id]
		attendance.destroy
		redirect_to '/events/'
	end
	def join
		Attendance.create(user:User.find(session[:id]), event:Event.find(params[:id]))
		redirect_to '/events/'
	end
	def create
		event=Event.new(events_params)
		if event.save
			redirect_to '/events/'
		else
			flash[:errors]=event.errors.full_messages
			redirect_to '/events/'
		end
	end
	def show
		@event=Event.find(params[:id])
	end
	def comment
		comment=Comment.new(comment:params[:comment], user:User.find(session[:id]), event:Event.find(params[:id]))
		if comment.save
			redirect_to "/events/#{params[:id]}"
		else
			flash[:errors]=comment.errors.full_messages
			redirect_to "/events/#{params[:id]}"
		end
	end
	private 
	def events_params
		user = User.find(session[:id])
		params.require(:events).permit(:name, :date, :city, :state).merge(:host=>user)
	end
end
