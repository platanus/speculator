class CalculateVpin < Command.new(:account, :block_size)
  def perform
    remaining = block_size
    sum = 0

    account.transactions.order('timestamp DESC').find_each do |tx|
      if remaining < tx.volume
        sum += tx.instruction.bid? ? remaining : (-1 * remaining)
        break
      else
        sum += tx.instruction.bid? ? tx.volume : (-1 * tx.volume)
        remaining -= tx.volume
      end
    end

    sum / (block_size - remaining)
  end
end
