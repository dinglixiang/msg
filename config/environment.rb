#require_relative 'application'
if ENV['DB']
	require_relative 'application'
	Rails.application.initialize!
else
	config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
	config['pool'] = ENV['DB_POOL'] || ENV['RAILS_MAX_THREADS'] || 20
	ActiveRecord::Base.establish_connection(config)

	require_all "#{Rails.root}/app/models"
	require_all "#{Rails.root}/app/services"
	require_all "#{Rails.root}/config/initializers/custom_error"

	app = HproseHttpService.new

	app.add(Msg::BaseService, :msg)
	app.add(User::BaseService, :user)

	Rack::Handler::WEBrick.run(app, {:Port => 5000})
end
