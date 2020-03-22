class Spree::Admin::WorkingHoursController < Spree::Admin::BaseController
  before_action :load_store_and_working_day

  def create
    working_hour = @working_day.working_hours.new(working_hours_params)
    if !working_hour.save
      flash[:error] = working_hour.errors.full_messages.join(", ")
    end

    redirect_to edit_admin_store_working_day_path(@store, @working_day)
  end

  def update
    working_hour = @working_day.working_hours.where(id: params[:id])
    working_hour.try(:update, working_hours_params)
    redirect_to edit_admin_store_working_day_path(@store, @working_day)
  end

  def destroy
    working_hour = @working_day.working_hours.where(id: params[:id]).first
    working_hour.try(:destroy)
    redirect_to edit_admin_store_working_day_path(@store, @working_day)
  end

  private

  def load_store_and_working_day
    @store = Spree::Store.find_by(id: params[:store_id])
    @working_day = @store.working_days.where(id: params[:working_day_id]).first

    if @store.blank? || @working_day.blank?
      redirect_to admin_path
    end
  end

  def working_hours_params
    params[:working_hour].permit(:start_time, :end_time)
  end
end
