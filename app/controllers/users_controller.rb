class UsersController < ApplicationController
    before_action :authenticate_user!
    def list
      render json: {'users': User.where.not(id: current_user.id)}
    end
  end