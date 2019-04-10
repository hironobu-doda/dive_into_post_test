class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  def agenda_mail(agenda,agenda_title)
    @agenda = agenda
    @agenda_title = agenda_title

    mail to: @agenda.email, subject: "Agenda削除メール"
  end
end
