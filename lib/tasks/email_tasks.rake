desc 'get user emails'
task get_emails: :environment do
      User.all.find_each {|user| GetEmails.perform_async(user.id)}
end