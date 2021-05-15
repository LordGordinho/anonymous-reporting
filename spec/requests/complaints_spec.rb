require 'rails_helper'

RSpec.describe 'complaint API' do
  before { host! 'localhost' }

  let!(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
		{
		  'Content-Type' => Mime[:json].to_s,
		  'access-token' => auth_data['access-token'],
		  'uid' => auth_data['uid'],
		  'client' => auth_data['client']
		}
  end

  describe 'GET /complaints' do
    context 'when no filter param is sent' do
      before do
        create_list(:complaint, 5, user_id: user.id)
        get '/complaints', params: {}, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 5 complaints from database' do
        expect(json_body[:complaints].count).to eq(5)
      end      
    end
  end

  describe 'GET /complaints/:id' do
    let(:complaint) { create(:complaint, user_id: user.id) }

    before { get "/complaints/#{complaint.id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for complaint' do
      expect(json_body[:complaint][:description]).to eq(complaint.description)
    end
  end


  describe 'POST /complaints' do
    before do
      post '/complaints', params: { complaint: complaint_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:complaint_params) { attributes_for(:complaint) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the complaint in the database' do
        expect( Complaint.find_by(description: complaint_params[:description]) ).not_to be_nil
      end

      it 'returns the json for created complaint' do
        expect(json_body[:complaint][:description]).to eq(complaint_params[:description])
      end

      it 'assigns the created complaint to the current user' do
        expect(json_body[:complaint][:user_id]).to eq(user.id)
      end      
    end

    context 'when the params are invalid' do
      let(:complaint_params) { attributes_for(:complaint, description: ' ') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not save the complaint in the database' do
        expect( Complaint.find_by(description: complaint_params[:description]) ).to be_nil
      end

      it 'returns the json error for description' do
        expect(json_body[:errors]).to have_key(:description)
      end
    end
  end

  describe 'PUT /complaints/:id' do
    let!(:complaint) { create(:complaint, user_id: user.id) }

    before do
      put "/complaints/#{complaint.id}", params: { complaint: complaint_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:complaint_params){ { description: 'New complaint description' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json for updated complaint' do
        expect(json_body[:complaint][:description]).to eq(complaint_params[:description])
      end

      it 'updates the complaint in the database' do
        expect( Complaint.find_by(description: complaint_params[:description]) ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:complaint_params){ { description: ' '} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for description' do
        expect(json_body[:errors]).to have_key(:description)
      end

      it 'does not update the complaint in the database' do
        expect( Complaint.find_by(description: complaint_params[:description]) ).to be_nil
      end
    end
  end

  describe 'POST /complaints/:id/change_status' do
    let!(:complaint) { create(:complaint, user_id: user.id) }

    before do
      post "/complaints/#{complaint.id}/change_status", params: { complaint: complaint_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:complaint_params){ { status: "analyzing" } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json for updated complaint' do
        expect(json_body[:complaint][:status]).to eq(complaint_params[:status])
      end

      it 'updates the complaint in the database' do
        expect( Complaint.find_by(status: complaint_params[:status]) ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:complaint_params){ { status: 9999 } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for title' do
        expect(json_body[:errors]).to eq('is not a valid status')
      end

      it 'does not update the complaint in the database' do
        expect( Complaint.find_by(status: complaint_params[:status]) ).to be_nil
      end
    end
  end

end