class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :phone, :title, :gender, :office_phone, :agency_attributes, :authentication_tokens, :trip_users, :trips_manageds
  # attr_accessible :title, :body
  attr_accessible :agency_id, :role_id


  has_many :logos, :as => :imageable
  belongs_to :agency

  belongs_to :role

  validates_presence_of :first_name, :on => :update
  validates_presence_of :last_name, :on => :update
  validates_presence_of :email

  after_create :send_invitation
  
  def full_name
    [first_name, last_name].compact.join(' ').titleize.string_or_nil || email
  end

  def send_invitation
    if !self.role.blank?
      EmailSender.invitation_email(self).deliver if self.role.id==Role.agency_user.id
    end
  end

  def owns?(agency)
    if agency.is_a? Agency
      return agency.owner_id == self.id
    end
    false
  end

  def profile_complete?
    self.first_name.present? && self.last_name.present?
  end

  def admin?
    self.role_id == Role.agency_admin.id
  end

  def is_active?
    return self.sign_in_count > 0
  end

  def full_title
    return self.title.capitalize unless self.title.blank?
  end

end
