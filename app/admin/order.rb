ActiveAdmin.register Order do
  belongs_to :account

  scope :open
end
