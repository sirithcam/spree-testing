# frozen_string_literal: true

module GmailHelper
  def email_message(email)
    raw_html = email.message.body.to_s.force_encoding('utf-8')
    Sanitize.fragment(raw_html).split.join(' ')
  end
end
