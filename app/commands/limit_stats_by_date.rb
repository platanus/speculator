class LimitStatsByDate < Command.new(:stats, :limit)
  STEP = 2.months

  def perform
    ref = stats.reorder('created_at DESC').offset(limit).first
    stats.where('created_at >= ?', ref.created_at)
  end
end
