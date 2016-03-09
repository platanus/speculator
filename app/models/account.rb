class Account < ActiveRecord::Base

  belongs_to :robot
  has_many :orders, inverse_of: :account, dependent: :destroy

  validates :name, :exchange, presence: true
  validates :base_currency, :quote_currency, presence: true
  validates :new_credentials, yaml_hash: true, allow_nil: true

  before_save :save_credentials_and_clear, if: :credentials_changed?

  def new_credentials=(_value)
    @new_credentials = _value.empty? ? nil : _value
    @credentials_changed = true
  end

  def new_credentials
    @new_credentials
  end

  def credentials_changed?
    !!@credentials_changed
  end

  def credentials
    CredentialEncryptionService.decrypt encrypted_credentials
  end

  def parsed_credentials
    credentials.tap do |creds|
      return { } if creds.nil?
      return YAML.load(creds).symbolize_keys
    end
  end

  private

  def save_credentials_and_clear
    self.encrypted_credentials = CredentialEncryptionService.encrypt new_credentials
    @new_credentials = nil
    @credentials_changed = false
    nil
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                    :integer          not null, primary key
#  robot_id              :integer
#  name                  :string(255)
#  exchange              :string(255)
#  base_currency         :string(255)
#  quote_currency        :string(255)
#  encrypted_credentials :text(65535)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_accounts_on_robot_id  (robot_id)
#
