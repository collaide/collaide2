# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  before_action :find_user, only: [:groups]

  def show
    @user = User.find(params[:id])
  end

  def groups
    @groups = @user.groups
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
