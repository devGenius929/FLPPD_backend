SwaggerEngine.configure do |config|
  config.json_files = {
      'api-docs': 'lib/swagger/api-docs.json'
  }
end

Rails.application.config.assets.precompile += %w( swagger_engine/reset.css )
Rails.application.config.assets.precompile += %w( swagger_engine/print.css )