class GetEmails
   include Sidekiq::Worker
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
end