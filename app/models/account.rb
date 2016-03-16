class Account < ActiveRecord::Base
  attr_encrypted :credentials, key: Base64.decode64(ENV['CREDENTIALS_SECRET'])

  belongs_to :robot
  has_many :orders, inverse_of: :account, dependent: :destroy

  validates :robot, :name, :exchange, presence: true
  validates :base_currency, :quote_currency, presence: true
  validates :credentials, yaml_hash: true, allow_nil: true, if: :credentials_changed?

  def parsed_credentials
    credentials.tap do |creds|
      return { } if creds.nil?
      return YAML.load(creds).symbolize_keys
    end
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                       :integer          not null, primary key
#  robot_id                 :integer
#  name                     :string(255)
#  exchange                 :string(255)
#  base_currency            :string(255)
#  quote_currency           :string(255)
#  encrypted_credentials    :text(65535)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  encrypted_credentials_iv :string(255)
#
# Indexes
#
#  index_accounts_on_robot_id  (robot_id)
#
