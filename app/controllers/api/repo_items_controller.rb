# -*- encoding : utf-8 -*-
class Api::RepoItemsController < ApplicationController
  after_filter :set_csrf_cookie_for_ng

  before_action :find_the_group
  before_action :find_the_repo, only: [:download, :copy, :move, :rename]

  # GET /group/work_groups/1
  # GET /group/work_groups/1.json
  def show
    @repo_item = RepositoryManager::RepoItem.find(params[:id])
    if @repo_item.is_folder?
      @children = @repo_item.children.order(name: :asc).order(file: :asc)
    else
      @children = []
    end
  end

  # Affiche le répertoire de base
  def index
    @repo_items = @group.root_repo_items.includes(:owner).includes(:sender).order(name: :asc).order(file: :asc)
  end

  def create_file
    repo_item  = repo_item_if_exist file_params[:id]
    options = {source_folder: repo_item, sender: current_user}
    respond_to do |format|
      if (@item = @group.create_file(params.require(:file), options))
        format.json { render template: 'api/repo_items/create', status: :created }
      else
        format.json { render json: options[:errors], status: :unprocessable_entity }
      end
    end
  end

  def create_folder
    folder_params = params.require(:repo_folder).permit(:id, :name)
    repo_item = repo_item_if_exist folder_params[:id]
    options = {source_folder: repo_item, sender: current_user}
    respond_to do |format|
      if @item = @group.create_folder(folder_params[:name], options)
        format.json { render template: 'api/repo_items/create', status: :created }
      else
        format.json { render json: options[:errors], status: :unprocessable_entity }
      end
    end
  end

  def download
    path = @group.download_repo_item(@repo_item)
    # Si le fichier n'est pas trouvé
    render status: :bad_request and return unless File.exist?(path)

    send_file_options = {disposition: :inline, filename: @repo_item.name}
    if MIME::Types.type_for(path).any?
      send_file_options[:type] = MIME::Types.type_for(path).first.content_type
    end
    send_file_options[:x_sendfile] = true if Rails.env == 'production' # For apache
    send_file(path, send_file_options)
  end

  def destroy
    @repo_item = RepositoryManager::RepoItem.find(params[:id])

    if @repo_item.is_folder?
      notice = t 'repository_manager.destroy.repo_folder.success', item: @repo_item.name
    else
      notice = t 'repository_manager.destroy.repo_file.success', item: @repo_item.name
    end
    respond_to do |format|
      if @group.delete_repo_item(@repo_item)
        format.json { render json: {notice: notice} }
      else
        format.json { render json: repo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy
    copy_params = params.require(:repo_item).permit :id
    target = repo_item_if_exist copy_params[id]
    respond_to do |format|
      if @group.copy_repo_item(@repo_item, source_folder: target)

        format.json { render :show }
      else
        format.json { render json: @repo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    move_params = params.require(:repo_item).permit :id
    target = repo_item_if_exist move_params[id]
    respond_to do |format|
      if @group.move_repo_item @repo_item, source_folder: target
        format.json { render :show }
      else
        format.json { render json: @repo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def rename
    respond_to do |format|
      if @group.rename_repo_item @repo_item, params[:repo_item][:name]
        format.json { render :show }
      else
        format.json { render json: @repo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

  private

  def repo_item_if_exist(id)
    RepositoryManager::RepoItem.where(id: id).take
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def file_params
    if params[:repo_file].present?
      params.require(:repo_file).permit(:id, :file)
    else
      {}
    end
  end

  def find_the_group
    @group = Group::Group.find(params[:group_group_id])
  end

  def find_the_repo
    @repo_item = RepositoryManager::RepoItem.find(params[:repo_item_id])
  end
end
