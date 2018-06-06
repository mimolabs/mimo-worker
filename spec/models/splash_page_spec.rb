require 'rails_helper'

RSpec.describe SplashPage, type: :model do
  describe 'should change the password and send emails' do
    it 'should send the daily password' do
      spl = SplashPage.create password: 'secure-passy'
      
      SplashPage.send_daily_passwords
      expect(spl.reload.password).to eq 'secure-passy'

      spl.update(
        passwd_auto_gen: true,
        passwd_change_email: Faker::Internet.email, 
        passwd_change_day: [0,1,2,3,4,5,6], 
        backup_password: true
      )

      SplashPage.send_daily_passwords
      # expect(spl.reload.password).to eq 'secure-passy'

      expect(spl.reload.password).to_not eq 'secure-passy'
    end

    it 'should find all the splash pages with passy auto gen enabled' do
      expect(SplashPage.with_passwd_auto_gen.size).to eq 0
      SplashPage.create(
        password: 'secure-passy', 
        passwd_auto_gen: true,
        passwd_change_email: Faker::Internet.email, 
        passwd_change_day: [0,1,2,3,4,5,6], 
        backup_password: true
      )
      expect(SplashPage.with_passwd_auto_gen.size).to eq 1
    end
  end
end
