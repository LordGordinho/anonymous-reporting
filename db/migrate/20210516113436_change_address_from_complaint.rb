class ChangeAddressFromComplaint < ActiveRecord::Migration[6.1]
  def change
    change_column :complaints, :address, :text
  end
end
