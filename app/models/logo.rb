class Logo < ActiveRecord::Base
  attr_accessor :image_width, :image_height
  attr_accessor :crop_w, :crop_h, :crop_x, :crop_y
  attr_accessible :current, :crop_w, :crop_h, :crop_x, :crop_y

  belongs_to :imageable, :polymorphic => true
  after_update :reprocess_profile, :if => :cropping?

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  mount_uploader :image, ImageUploader

private
  def reprocess_profile
    image.recreate_versions!
  end
end
