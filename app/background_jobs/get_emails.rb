class GetEmails
   include Sidekiq::Worker
   def perform user_id
   	user = User.find_by(user_id)
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.authenticate('XOAUTH2', self.email, self.access_token)
    imap.select('INBOX')
    imap.search(['ALL']).each do |message_id|
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string msg
      Email.create(:user_id => user.id, :subject => mail.subject.to_s, :text_part => mail.text_part,
      :from => mail.from.to_s, :to => mail.to.to_s, :date => mail.date )
      end
   end
end