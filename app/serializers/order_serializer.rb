class OrderSerializer < ActiveModel::Serializer
  attributes :id, :price, :volume, :pending_volume, :instruction
end
