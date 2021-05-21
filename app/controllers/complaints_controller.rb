class ComplaintsController < ApplicationController

  # before_action :authenticate_user!

  def index
    complaints = Complaint.all.page(params[:page] || 1).per(params[:per_page] || 20)
    if complaints
      render json: { complaints: complaints }, status: 200
    end
  end

  def show
    complaint = Complaint.find(params[:id])

    if complaint
      render json: { complaint: complaint }, status: 200
    end
  end

  def search
    complaints = Complaint.ransack(params[:q]).result.page(params[:page] || 1).per(params[:per_page] || 20)
    render json: { complaints: complaints}, status: 200
  end

  def create
    # complaint = current_user.complaints.build(complaint_params)
    user = User.find_by(id: 4)
    complaint = Complaint.new(complaint_params)
    complaint.user = user
    byebug
    complaint.address = AddressService.new({lat: complaint_params[:lat], long: complaint_params[:long] }).call
    byebug
    if (complaint_params[:lat] != nil && complaint_params[:long] != nil ) && (complaint.address == {} )
      render json: { errors: 'invalid locality' }, status: 422
    elsif complaint.save
      render json: { complaint: complaint}, status: 201
    else
      render json: { errors: complaint.errors }, status: 422
    end
  end

  def update
    complaint = current_user.complaints.find(params[:id])

    if complaint.update(complaint_params)
        render json: { complaint: complaint }, status: 200
    else
        render json: { errors: complaint.errors }, status: 422
    end
        
  end

  def change_status
    complaint = Complaint.find(params[:id])
    begin
      complaint.update(params_status)
      render json: { complaint: complaint }, status: 200
    rescue Exception
      render json: { errors: 'is not a valid status' }, status: 422
    end
  end
  
  def complaint_params
    params.require(:complaint).permit(:description, :lat, :long)
  end

  def params_status
    params.require(:complaint).permit(:status, :name)
  end
end
