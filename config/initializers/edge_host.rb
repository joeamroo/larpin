# The larpin.io zone is served through a Cloudflare Worker that proxies to the
# Railway service domain. Railway's edge overwrites X-Forwarded-Host, so the
# worker smuggles the original host in X-Larpin-Host; restore it here so all
# generated URLs (shares, OG tags, redirects) use larpin.io.
class EdgeHostRestore
  def initialize(app)
    @app = app
  end

  def call(env)
    if (host = env["HTTP_X_LARPIN_HOST"]).present? && host.match?(/\A[a-z0-9.-]+\z/i)
      env["HTTP_HOST"] = host
      env["HTTP_X_FORWARDED_HOST"] = host
    end
    @app.call(env)
  end
end

Rails.application.config.middleware.insert_before ActionDispatch::HostAuthorization, EdgeHostRestore
