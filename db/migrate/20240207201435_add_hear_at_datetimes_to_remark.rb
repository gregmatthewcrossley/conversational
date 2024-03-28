class AddHearAtDatetimesToRemark < ActiveRecord::Migration[7.1]
  def change
    # add_column :remarks, :sent_at, :datetime
    add_column :remarks, :sent_at, :datetime
  end
end
