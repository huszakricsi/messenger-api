class ProfileController < ApplicationController
    before_action :authenticate_user!
    def update
      if  params[:name] != nil
        current_user.name=params[:name]
      end
      if params[:nickname] != nil
        current_user.nickname=params[:nickname]
      end
      render json: {'success': current_user.save}
    end
  end