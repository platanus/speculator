namespace :bots do
  desc "Starts the bot dispatcher"
  task :dispatch, [:sleep] => [:environment] do |_t, args|

    Rails.logger = Logger.new(STDOUT)

    dispatcher = RobotDispatcherService.new
    dispatcher.sleep = args[:sleep].to_f if args[:sleep]

    Signal.trap("INT") { |sig| Thread.new { dispatcher.stop } }
    Signal.trap("TERM") { |sig| Thread.new { dispatcher.stop } }

    Rails.logger.info "Starting bot dispatcher"

    dispatcher.run

    Rails.logger.info "Stopping bot dispatcher"
  end
end
