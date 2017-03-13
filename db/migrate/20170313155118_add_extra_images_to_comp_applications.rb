class AddExtraImagesToCompApplications < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :comp_applications, :extra_image1
    add_attachment :comp_applications, :extra_image2
  end

  def self.down
    remove_attachment :comp_applications, :extra_image1
    remove_attachment :comp_applications, :extra_image2
  end
end
