class ApplicationMailer < ActionMailer::Base
  default from: "imGrätzl.at <no-reply@imgraetzl.at>"
  layout 'mailer'

  def self.inherited(subclass)
    subclass.default template_path: "mailers/#{subclass.name.to_s.underscore}"
  end

end
