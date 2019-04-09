class TeamMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  def team_mail(team)
    @team = team
    mail to: @team, subject: "リーダー変更のお知らせメール"
  end
end
