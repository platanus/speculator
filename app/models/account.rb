require 'forwardable'

class Account < ActiveRecord::Base
  extend Forwardable

  belongs_to :robot
  has_many :orders, inverse_of: :account, dependent: :destroy

  validates :name, :exchange, presence: true
  validates :base_currency, :quote_currency, presence: true
  validates :credentials, yaml_hash: true, allow_nil: true

  def pair
    @pair ||= Trader::CurrencyPair.for_code(base_currency.to_sym, quote_currency.to_sym)
  end

  def core_account
    @core ||= load_core_account
  end

  def_delegators :core_account, :base_balance, :quote_balance

  def credentials=(_value)
    @credentials = _value
  end

  def credentials
    return @credentials if @credentials
    return nil if encrypted_credentials.nil?
    CredentialEncryptionService.decrypt(encrypted_credentials)
  end

  def parsed_credentials
    credentials.tap do |creds|
      return nil if creds.nil?
      return HashWithIndifferentAccess.new YAML.load creds
    end
  end

  private

  def save_decrypted_credentials
    if @credentials
      self.encrypted_credentials = CredentialEncryptionService.encrypt @credentials
      @credentials = nil
    end
  end

  def load_core_account
    base_account = Trader.account exchange, parsed_credentials
    base_account.using pair
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
