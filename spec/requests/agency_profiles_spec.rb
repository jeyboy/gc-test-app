require 'spec_helper'

describe "Agency Profiles" do
  before(:all) {Agency.create(:name => "qwerty")}

  describe 'Crop' do
    before(:each) do
      @logo = Agency.first.logos.build
      @logo.image = Rack::Test::UploadedFile.new("#{Rails.root.to_s}/rails.png", "image/png")
      @logo.save
      visit '/'
    end

    it "check crop", :js => true do
      find('.add').click
      find('.photos ul li:first').click

    end
  end
end
