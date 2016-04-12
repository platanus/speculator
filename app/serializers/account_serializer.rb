class AccountSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :exchange, :base_currency, :quote_currency,
    :base_balance, :quote_balance

  def base_balance
    RobotContextService.new(object.robot).apply do
      SyncAccount.new(object).base_balance.amount.amount rescue nil
    end
  end

  def quote_balance
    RobotContextService.new(object.robot).apply do
      SyncAccount.new(object).quote_balance.amount.amount rescue nil
    end
  end
end
