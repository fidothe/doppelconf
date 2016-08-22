require 'hanami/helpers'
require 'hanami/assets'

module Web
  class Application < Hanami::Application
    configure do
      # I stripped out comments and dead code here, otherwise default

      root __dir__
      load_paths << [
        'controllers',
        'views'
      ]
      routes 'config/routes'

      # Here's the important bit
      class DoppelMid
        def initialize(app)
          @app = app
        end
        def call(env)
          @app.call(env)
        end
      end
      middleware.use DoppelMid
      puts caller
      p middleware

      layout :application # It will load Web::Views::ApplicationLayout
      templates 'templates'
      assets do
        sources << [
          'assets'
        ]
      end
      security.x_frame_options 'DENY'
      security.x_content_type_options 'nosniff'
      security.x_xss_protection '1; mode=block'
      security.content_security_policy %{
        form-action 'self';
        frame-ancestors 'self';
        base-uri 'self';
        default-src 'none';
        script-src 'self';
        connect-src 'self';
        img-src 'self' https: data:;
        style-src 'self' 'unsafe-inline' https:;
        font-src 'self';
        object-src 'none';
        plugin-types application/pdf;
        child-src 'self';
        frame-src 'self';
        media-src 'self'
      }
      controller.prepare do
        # include MyAuthentication # included in all the actions
        # before :authenticate!    # run an authentication before callback
      end
      view.prepare do
        include Hanami::Helpers
        include Web::Assets::Helpers
      end
    end
    configure :development do
      handle_exceptions false
    end
    configure :test do
      handle_exceptions false
      logger.level :error
    end
    configure :production do
      logger.level :info
      logger.format :json
      assets do
        compile false
        digest  true
        subresource_integrity :sha256
      end
    end
  end
end
