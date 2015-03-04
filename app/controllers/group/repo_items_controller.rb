# -*- encoding : utf-8 -*-
class Group::RepoItemsController < ApplicationController
  
  before_action :find_the_group
  
  def index
  end
  
  def show
  end

  private
  def find_the_group
    @group = Group::Group.find params[:group_group_id]
  end
end
