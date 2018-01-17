class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  # NOTE: be sure to configure history-tracking for each subclass

  # Returns an array of subclasses (e.g. [GuestAccount, UniversityAccount])
  TYPES =
    if Account.descendants.present?
      Account.descendants.map(&:to_s)
    else
      ['GuestAccount', 'UniversityAccount']
    end

  belongs_to :person, index: true

  field :modified_by, type: String

  field :confirmation_key, type: String
  field :confirmed_at, type: DateTime
  before_create :set_confirmation_key

  alias confirmed? confirmed_at?

  def unconfirmed?
    !confirmed?
  end

  # the url that sent the user to the sign up form (based on request data)
  field :referring_url, type: String # on sign up

  # the url that the user needs to be sent do after sign up (based on param)
  field :return_url, type: String # on sign up

  # TODO: decide if this should be called in the subclasses and/or here.
  track_history on: [:fields],
                track_create: true,
                track_update: true,
                tracker_class_name: :account_history_tracker
  def uuid
    person.try(:uuid)
  end

  private

  def set_confirmation_key
    self.confirmation_key = SecureRandom.hex
  end

  ## This was pulled over from three-keepers but isn't needed as there won't be
  ## any user interaction through the syncinators.
  # before_save :tag_user
  #
  # def tag_user
  #   self.modified_by = current_user_stamp.to_s
  # end
  #
  # def current_user_stamp
  #   return ENV['SUDO_USER'] || ENV['USER'] unless CurrentUserPresenter.current
  #   current_user = CurrentUserPresenter.current
  #   return current_user.username if current_user.not_a_guest_account?
  #   return current_user.guest_account.uuid if current_user.guest_account
  #   nil
  # end
end
