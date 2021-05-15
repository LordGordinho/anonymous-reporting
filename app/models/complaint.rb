class Complaint < ApplicationRecord
  belongs_to :user

  validates_presence_of :description, :user_id, :lat, :long

  enum status: [ :pending, :analyzing, :judged,  :rejected ]
end
