#All application specific initialization is done here
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:pretty => "%B %d, %Y")  

#init site props
SITE_PROPS = YAML::load(File.open("#{RAILS_ROOT}/config/siteprops.yml"))

#Email Server Settings
set = SITE_PROPS['admin']['email']['server']
ActionMailer::Base.smtp_settings = {
                                        :address => set['host'],
                                        :port => set['port'],
                                        :domain => set['domain'],
                                        :user_name => set['user_name'],
                                        :password => set['password'],
                                        :authentication => :plain
                                        }

#make a pronouncable random string
def pronouncable_random(size=4)
  c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
  v = %w(a e i o u y)
  f, r = true, ''
  (size * 2).times do
    r << (f ? c[rand * c.size] : v[rand * v.size])
    f = !f
  end
  return r
end

#extend the numeric class to include some helper methods
class Numeric
  def positive?
    self >= 0
  end

  def negative?
    self < 0
  end
end
