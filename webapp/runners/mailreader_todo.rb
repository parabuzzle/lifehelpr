require 'mail'

#Mail.defaults do
#   retriever_method :imap, { :address             => "imap.lifehelpr.com",
#                             :port                => 143,
#                             :user_name           => 'todo@lifehelpr.com',
#                             :password            => 'wamu22',
#                             :enable_ssl          => false }
#end
#
#
#mail.parts[0].body.raw_source
#

Mail.defaults do
  retriever_method :pop3, { :address             => "imap.lifehelpr.com",
                            :port                => 110,
                            :user_name           => 'todo@lifehelpr.com',
                            :password            => 'wamu22',
                            :enable_ssl          => false }
end

Mail.all    #=> Returns an array of all emails
Mail.first  #=> Returns the first unread email
Mail.last   #=> Returns the first unread email
  