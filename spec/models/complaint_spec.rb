require 'rails_helper'

RSpec.describe Complaint, type: :model do
  let!(:user) { create(:user)}
  let(:complaint) { build(:complaint, user: user) }
  
  it { expect(complaint).to be_valid }    

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :user_id }

  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:lat) }
  it { is_expected.to respond_to(:long) }
  it { is_expected.to respond_to(:status) }


  it 'when tha complaint is new' do
      expect(complaint.status).to eq('pending')
  end

  it { is_expected.to respond_to(:user_id) }
end
