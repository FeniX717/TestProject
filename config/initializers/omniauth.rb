Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "#{Rails.application.secrets.app_id}", "#{Rails.application.secrets.app_secret}", scope: 'https://www.googleapis.com/auth/userinfo.email,https://www.googleapis.com/auth/gmail.readonly, https://mail.google.com/'
end

