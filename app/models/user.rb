class User < ActiveRecord::Base
  has_many :emails

  def self.from_omniauth(auth)
    find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = auth["info"]["email"]
      user.access_token = auth["credentials"]["token"]
      user.access_expires_at = Time.at(auth["credentials"]["expires_at"])
      user.refresh_token = auth["credentials"]["refresh_token"]
      user.save!
    end
  end

  def get_emails 
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.authenticate('XOAUTH2', self.email, self.access_token)
    imap.select('INBOX')
    imap.search(['ALL']).each do |message_id|
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string msg
      unless Email.find_by_message_id(mail.message_id)
        Email.create(:user_id => self.id, :subject => mail.subject.to_s, :text_part => mail.text_part,
        :from => mail.from.to_s, :to => mail.to.to_s, :date => mail.date, :message_id => mail.message_id)
      end
    end
  end

  def token_expired?
    expiry = self.access_expires_at
    return true if expiry < Time.now 
    token_expires_at = expiry
    save if changed?
    false 
  end

  def refresh_token_if_expired(refresh_token)
    if token_expired?
      data = {
        :client_id => "#{Rails.application.secrets.app_id}",
        :client_secret => "#{Rails.application.secrets.app_secret}",
        :refresh_token => refresh_token,
        :grant_type => "refresh_token"
      }
      @response = ActiveSupport::JSON.decode(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
      if @response["access_token"].present?
        self.access_token = @response['access_token']
        self.access_expires_at = DateTime.now + @response["expires_in"].to_i.seconds
        self.save
        puts 'Saved'
      else
        puts "Unsaved"
      end
    end
  end
end
