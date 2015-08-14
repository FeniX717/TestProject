require 'rest-client'

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
      Email.create(:user_id => self.id, :subject => mail.subject.to_s, :text_part => mail.text_part,
      :from => mail.from.to_s, :to => mail.to.to_s, :date => mail.date )
    end
  end


  def refresh_token_if_expired
    if token_expired?
      response = RestClient.post "https://accounts.google.com/o/oauth2/token", :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => "#{Rails.application.secrets.app_id}",
      :client_secret => "#{Rails.application.secrets.app_secret}", refreshhash = JSON.parse(response.body)

      token_will_change!
      expiresat_will_change!

      self.access_token     = refreshhash['access_token']
      self.access_expires_at = DateTime.now + refreshhash["expires_in"].to_i.seconds

      self.save
      puts 'Saved'
    end
  end

  def token_expired?
    expiry = self.access_expires_at
    return true if expiry < Time.now 
    token_expires_at = expiry
    save if changed?
    false 
  end

end
