class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  # default from: "info@students.koi.edu.au"
  layout "mailer"
end
