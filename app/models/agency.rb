class Agency < ActiveRecord::Base
  attr_accessible :address, :city, :name, :phone, :state_id, :url, :zip_code, :subdomain, :owner_attributes
  
  has_many :users
  has_many :logos, :as => :imageable
  has_many :trips
  belongs_to :state

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  accepts_nested_attributes_for :owner

  has_many :admins, :class_name => 'User', :conditions => {:role_id => Role.agency_admin.try(:id)}
  has_many :users

  # just because trip has_many :addons, doesn't mean we can automagically
  # use the following association (has_many :through needs join models)
  # has_many :addons, :through => :trips

  before_create :capitalize_name

  validates_presence_of :name


  # if Rails.env.test?
  #   # This is just an awful workaround since capybara is not loading has_one association properly
  #   def admin
  #     users.find_by_role_id(Role.agency_admin.try(:id))
  #   end
  # end
  # 
  def profile_complete?
    self.subdomain.present? && self.name.present? && self.owner.profile_complete?
  end

  private

  def capitalize_name
    self.name.capitalize! unless self.name.blank?
  end

end
