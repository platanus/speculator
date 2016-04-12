class AccountSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :exchange, :base_currency, :quote_currency

  def created_at
    object.created_at.to_i
  end
end
