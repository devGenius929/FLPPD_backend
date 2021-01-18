class User < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :user do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :first_name do
      key :type, :string
    end
    property :last_name do
      key :type, :string
    end
    property :email do
      key :type, :string
    end
    property :phone_number do
      key :type, :string
    end
    property :about do
      key :type, :string
    end
    property :avatar do
      key :type, :string
    end
    property :auth_token do
      key :type, :string
    end
    property :firebase_password do
      key :type, :string
    end
    property :role do
      key :type, :string
      key :description, 'Wholesaler, Investor, Builder, Remodeler, Realtor, Consumer, Undefined'
    end
    property :city do
      key :type, :string
    end
    property :state do
      key :type, :string
    end
    property :rank do
      key :type, :string
      key :description, 'Low, Average, High'
    end
    property :hauses_sold do
      key :type, :integer
    end
  end

  #password encryp
  has_secure_password

  #MailBoxer
  acts_as_messageable


  #RELATIONSHIP SECTION
  has_many :properties

  has_many :networks
  has_many :received_networks, class_name: "Network", foreign_key: "friend_id"

  #This return all the friends who u sent connection request
  has_many :active_friends, -> { where(networks: { status: true }) }, through: :networks, source: :friend
  #This return all the friends who sent u the connection request
  has_many :received_friends, -> { where(networks: { status: true }) }, through: :received_networks, source: :user
  #This return all the users pending requests for your answer
  has_many :pending_friends, -> { where(networks: { status: false }) }, through: :received_networks, source: :user
  #This return all the users connection requests what you are waiting for answer
  has_many :requested_friendships, -> { where(networks: { status: false }) }, through: :networks, source: :friend
  has_many :devices
  #END RELATIONSHIPS


  #actiaveted is for email
  #verified is for phone number
  validates :password, length: { minimum: 6 }, allow_blank: true


  ## default params for the model
  attr_accessor   :activation_token, :reset_token
  before_save     :downcase_email
  before_save     :capitalize_first_name
  before_save     :capitalize_last_name
  before_create   :create_activation_digest
  before_create   :create_avatar
  before_create   :create_customer


  ## VALIDATIONS SECTION
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: true }
  validates :password, presence: true, length: { minimum: 6 }, allow_blank: true
  validates :phone_number, presence: true,
                    format: { with: /\+\d{1,3}\s\d{2,3}\s\d{3,4}\s\d{4}/, message: "bad format"},
            length: { maximum: 15, minimum: 12 }
  VALID_NAME_REGEX = /[a-zA-Z]*/
  validates :first_name,  presence: true, length: { maximum: 50 },
                          format: { with: VALID_NAME_REGEX, message: "Your first name can only contain letters" }
  validates :last_name,  presence: true, length: { maximum: 50 },
                         format: { with: VALID_NAME_REGEX, message: "Your last name can only contain letters" }
  #validates :password_confirmation, :presence => true, :if => '!password.nil?'
  ## END VALIDATIONS


  #Returning any kind of identification you want for the model
  def name
    return self.first_name
  end

  #Returning the email address of the model if an email should be sent for this object (Message or Notification).
  #If no mail has to be sent, return nil.
  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    return self.email
    #if false
    #return nil
  end

  #get all network request
  def all_network_request
    networks | received_networks
  end

  # to call all your friends
  def friends
    active_friends | received_friends
  end

  def common_friends_with(user_id)
    (friends.map(&:id) & User.find(user_id).friends.map(&:id)).length
  end

  # to call your pending sent or received
  def pending
      pending_friends | requested_friendships
  end


  def getConversationFriend(conversation)
    if(self.id != conversation.message.sender_id)
      return User.find(conversation.message.sender_id)
    elsif (self.id != conversation.receiver_id)
      return User.find(conversation.receiver_id)
    end
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #activates an account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def self.jsonAfterAction(user, token)
    return {auth_token: token, user_id: user.id, name: user.first_name, last_name: user.last_name, email: user.email, phone_number: user.phone_number}
  end

  #account/phonenumber verification
  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    save
  end

  def twilio_client
    Twilio::REST::Client.new(ENV["TWILLIO_SID"], ENV["TWILLIO_AUTH_TOKEN"])
  end

  def send_pin
    twilio_client.messages.create(
      To: phone_number,
      From:  ENV['TWILLIO_FROM_NUMBER'],
      body: "Your PIN is #{pin}"
    )
  end

  def subscriptions
    Stripe::Customer.retrieve(self.customer_id).subscriptions.data
  end

  def subscribed?
    if self.subscriptions.count > 0
      true
    else
      false
    end
  end

  def subscribtion_active?
    if self.subscribed?
      if self.subscriptions[0].status == "active" || self.subscriptions[0].status == "trialing"
        true
      else
        false
      end
    else
      false
    end
  end

  def subscription_cancelled?
    if self.subscriptions[0].cancel_at_period_end
      true
    else
      false
    end
  end


  def creditcard?
    if Stripe::Customer.retrieve(self.customer_id).sources.data.count > 0
      true
    else
      false
    end
  end

  def fullname
    (self.first_name+' '+self.last_name).titleize
  end

  def verify(entered_pin)
    update(verified: true) if self.pin == entered_pin
  end

  #password reset and welcome email methods
  def send_welcome_email
    UserMailer.welcome_message(self).deliver_later
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver_later
  end

  def send_sms_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    twilio_client.messages.create(
      To: phone_number,
      From:  "+18327722464",
      body: "Your password reset code is #{self.password_reset_token}"
    )
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex(3).upcase
    end while User.exists?(column => self[column])
  end

  def after_reseted_pass
    self.password_reset_token = nil
    save!
  end

  def check_firebase_password
    update_attribute(:firebase_password, User.new_token) if firebase_password.blank?
  end

  private
  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  def capitalize_first_name
    self.first_name = first_name.capitalize
  end

  def capitalize_last_name
    self.last_name = last_name.capitalize
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_avatar
    self.avatar = "#{ENV['HOST']}img/default_avatar.jpg"
  end

  def create_customer
    customer= Stripe::Customer.create(
      :description => self.email
    )
    self.customer_id= customer.id
  end
  
  #search users by name
  def self.search(search)
    if search.present?
      where('lower(first_name) LIKE ? or lower(last_name) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%")
    end
  end

end
