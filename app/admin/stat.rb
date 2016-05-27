ActiveAdmin.register RobotStat do
  belongs_to :robot

  controller do
    defaults :collection_name => :stats

    def apply_filtering(chain)
      chain = super chain
      chain = LimitStatsByDate.for(stats: chain, limit: params[:last].to_i) if params.key? :last
      chain
    end

    def apply_pagination(chain)
      chain = params.key?(:last) ? chain : super(chain)
    end
  end
end
