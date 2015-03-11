class Api::SearchController < ApplicationController
  respond_to :json


  def users
    if params[:term]
      @users = User.search_by_email_or_name(params[:term])
    else
      @users = [User.find(params[:id])]
    end
  end
end