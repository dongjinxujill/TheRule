class Api::ProjectsController < ApplicationController
  before_action :require_logged_in, only: [:create, :update, :destroy]

  def show
    @project = Project.includes(comments: :author).find(params[:id])
    if @project
      render :show
    else
      render json: ["project doesn't exist"], status: 404
    end
  end

  def search
    if params[:query]
      @projects = Project.where("lower(title) LIKE ?", "%#{params[:query]}%").all
    end
  end

  def index
    @projects = Project.all
  end

  def create
    @project = Project.new(project_params)
    @project.author_id = current_user.id
    if !@project.image
      render json: ["Image can't be blank"], status: 404
    end
    if @project.save
      render :show
    else
      render json: @project.errors.full_messages, status: 422
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.author_id != current_user.id
      render json: ["not authorized to update project"], status: 403
    elsif @project.update(project_params)
      render :show
    else
      render json: @project.errors.full_messages, status: 422
    end
  end

  def destroy
     @project = Project.find(params[:id])
     if @project.author_id == current_user.id
       @project.destroy
       render :show
     else
       render json: ["not authorized to destroy project"], status: 403
     end
   end

  private
  def project_params
    params.require(:project).permit(:title, :body, :image)
  end
end
