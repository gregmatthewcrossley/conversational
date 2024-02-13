class AddHearAtDatetimesToRemark < ActiveRecord::Migration[7.1]
  def change
    # add_column :remarks, :heard_at, :datetime
    add_column :remarks, :heard_at, :datetime
  end
end
