# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "MyFIFA Manager <myfifa@#{Socket.gethostname}>",
          'Message-ID' => -> { "<#{UUID.generate}@#{Socket.gethostname}>" }
  layout 'mailer'
end
