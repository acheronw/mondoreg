class AddPrimaryImagetoCompApplications < ActiveRecord::Migration[5.0]
  def self.up
    # This is a paperclip helper:
    add_attachment :comp_applications, :primary_image
  end

  def self.down
    # This is a paperclip helper:
    remove_attachment :comp_applications, :primary_image
  end
end
