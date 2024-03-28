class AddAudioBinaryBlobToRemark < ActiveRecord::Migration[7.1]
  def change
    add_column :remarks, :audio_binary_data, :binary
  end
end
