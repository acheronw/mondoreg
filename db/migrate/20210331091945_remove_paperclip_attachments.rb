class RemovePaperclipAttachments < ActiveRecord::Migration[6.1]
  def change
    # These are paperclip helpers:
    remove_attachment :comp_applications, :primary_image
    remove_attachment :comp_applications, :stage_music
    remove_attachment :comp_applications, :extra_image1
    remove_attachment :comp_applications, :extra_image2
  end
end
