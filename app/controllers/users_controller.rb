# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  before_action :find_user, only: [:groups, :notifications, :invitations]

  def show
    @user = User.find(params[:id])
  end

  def groups
    @groups = @user.groups
  end

  def notifications
    @notifications = @user.notifications.page(params[:page])
    render :notifications
    @notifications.each { |n| n.is_viewed = true unless n.is_viewed?; n.save }
  end

  def invitations
    @invitations = @user.received_invitations.wait_a_reply
    @email_invitations = @user.received_email_invitations.wait_a_reply
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
