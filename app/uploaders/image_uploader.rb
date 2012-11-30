# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  #process :store_meta

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [56,56]
  end

  # Image geometry
  before :cache, :capture_size_before_cache
  before :retrieve_from_cache, :capture_size_after_retrieve_from_cache

  def capture_size_before_cache(new_file)
    model.image_width, model.image_height = `identify -format "%wx%h" #{new_file.path}`.split(/x/)
  end

  def capture_size_after_retrieve_from_cache(cache_name)
    model.image_width, model.image_height = `identify -format "%wx%h" #{@file.path}`.split(/x/)
  end

  def dimensions
    "#{model.image_width}x#{model.image_height}"
  end
  # End image geometry

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end


  process :cropper

  def cropper
    return unless model.cropping?
    manipulate! do |img|
      img.crop(model.crop_x.to_i, model.crop_y.to_i, model.crop_w.to_i, model.crop_h.to_i)
    end
  end
end
