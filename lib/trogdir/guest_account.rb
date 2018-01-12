class GuestAccount < Account
  include ActiveModel::SecurePassword

  # We don't need a complicated email matcher since we confirm the email on the
  # account anyway but it's good to make sure up front that people don't try to
  # use a simple username that's not an email.
  VALID_EMAIL_MATCHER = /\A.+@.+\..+\Z/x

  field :uuid, type: String
  validates :uuid, presence: true, uniqueness: true
  before_validation :set_uuid, on: :create
  alias trogdir_id uuid

  field :first_name, type: String
  validates :first_name, presence: true

  field :last_name, type: String
  validates :last_name, presence: true

  field :username, type: String
  validates :username, uniqueness: { scope: :type, case_sensitive: false },
                       presence: true

  # Please remember to downcase the email anytime you work with it
  field :email, type: String
  validates :email, presence: true,
                    uniqueness: { scope: :type, case_sensitive: false },
                    format: { with: VALID_EMAIL_MATCHER }
  validates :email, format: { without: /@biola\.edu/,
                              message: 'can\'t be a @biola.edu address' }
  before_validation :downcase_email, :set_username

  field :password_digest, type: String
  has_secure_password

  # There is no field for password, because it does not get persisted.
  # But `has_secure_password` creates at attr_accessor for it so we can
  # write to the field and validate it. But it gets digested and saved in
  # the database in the `password_digest` field.
  # 'allow_nil' lets you save the model with blank values without actually
  # changing the password digest
  validates :password, length: { minimum: 8 },
                       allow_nil: true

  field :password_reset_key, type: String
  field :password_reset_email_sent_at, type: DateTime
  field :password_updated_at, type: DateTime

  # This explicitly disallows blank passwords since allow_nil lets save/update
  # return true even if the digest didn't actually change;
  def update_password(pwd, pwd_conf)
    if pwd.blank?
      errors[:password] = "Can't be blank."
      return false
    end

    update_attributes(password: pwd.to_s,
                      password_confirmation: pwd_conf.to_s,
                      password_updated_at: Time.now)
  end

  alias active? confirmed?

  field :archived_at, type: DateTime

  def archive!
    self.archived_at = Time.now
    save
  end

  def unarchive!
    self.archived_at = nil
    save
  end

  def archived?
    archived_at ? true : false
  end

  def name
    "#{first_name} #{last_name}"
  end

  track_history on: [:fields],
                track_create: true,
                track_update: true,
                tracker_class_name: :account_history_tracker

  private

  def set_username
    self.username ||= email
  end

  def downcase_email
    email.try(:downcase!)
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
