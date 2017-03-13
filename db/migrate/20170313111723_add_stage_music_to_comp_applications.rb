class AddStageMusicToCompApplications < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :comp_applications, :stage_music
  end

  def self.down
    remove_attachment :comp_applications, :stage_music
  end
end
