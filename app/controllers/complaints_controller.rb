class ComplaintsController < ApplicationController

  before_action :authenticate_user!
  include HTTParty

  def index
    complaints = Complaint.all
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
    complaints = Complaint.ransack(params[:q]).result
    render json: { complaints: complaints}, status: 200
  end

  def create
    complaint = current_user.complaints.build(complaint_params)
    
    res =  HTTParty.get "http://www.mapquestapi.com/geocoding/v1/reverse?key=e7Vf7zIzBVxfiHk6gDJ0zqiol6OmMVhW&location=#{complaint_params[:lat]},#{complaint_params[:long]}"
    location = JSON.parse(res.body)
    complaint.address = location['results'][0]['locations'][0]

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
  
  private 

  def complaint_params
    params.require(:complaint).permit(:description, :status, :lat, :long)
  end

  def params_status
    params.require(:complaint).permit(:status)
  end
end
