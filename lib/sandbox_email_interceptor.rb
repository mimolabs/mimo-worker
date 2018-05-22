class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['test@some-domain.com']
  end
end
