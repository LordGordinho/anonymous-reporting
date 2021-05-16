class Complaint < ApplicationRecord
  belongs_to :user

  validates_presence_of :description, :user_id

  enum status: [ :pending, :analyzing, :judged,  :rejected ]

  serialize :address, Hash
end
