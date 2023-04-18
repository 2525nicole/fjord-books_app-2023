# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page]).per(10).order(updated_at: :desc, id: :asc)
  end

  def show
    @user = User.find(params[:id])
  end
end
