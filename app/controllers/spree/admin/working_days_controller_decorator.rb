class Spree::Admin::WorkingDaysController < Spree::Admin::BaseController
  before_action :load_store

  def index
  end

  def create
    working_day = @store.working_days.new(working_day_params)
    working_day.save
    redirect_to admin_store_working_days_path(@store)
  end

  def edit
    @working_day = @store.working_days.where(id: params[:id]).first
  end

  def destroy
    @store.working_days.where(id: params[:id]).first.try(:destroy)
    redirect_to admin_store_working_days_path(@store)
  end

  private
  def load_store
    @store = Spree::Store.find_by(id: params[:store_id])

    if @store.blank?
      flash[:error] = "Store not found"
      redirect_to admin_path
    end
  end

  def working_day_params
    params.require(:working_day).permit(:name)
  end
end
