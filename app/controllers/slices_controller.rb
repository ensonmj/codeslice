class SlicesController < ApplicationController
  after_action :verify_authorized, :except => [:index, :show]

  def index
    @slices = Slice.order("updated_at desc").page(params[:page])
  end

  def create
    #render plain: params.inspect
    @slice = current_user.slices.new(slice_params)
    if @slice.save
      redirect_to @slice
    else
      render "new"
    end
  end

  def new
    @slice = Slice.new
  end

  def edit
    @slice = Slice.find(params[:id])
  end

  def show
    @slice = Slice.find(params[:id])
    @comments = @slice.comments.order("created_at").page(params[:page])
  end

  def update
    @slice = Slice.find(params[:id])
    authorize @slice
    if @slice.update(slice_params)
      redirect_to @slice
    else
      render "edit"
    end
  end

  def destroy
    @slice = Slice.find(params[:id])
    @slice.destroy

    redirect_to slices_path
  end

  private
  def slice_params
    params.require(:slice).permit(:title, :text, :note)
  end
end
