class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      render :new
    end
  end

  def destroy
    # @agenda_title = @agenda.title
    @agenda.team.members.each do |agenda|
      AgendaMailer.agenda_mail(agenda,@agenda.title).deliver
    end

    @agenda.destroy
    redirect_to dashboard_url, notice: 'アジェンダを削除しました！'
  end

  private

  def set_agenda
    # if current_user.id == @working_team.owner_id || current_user.id == agenda.user.id
      @agenda = Agenda.find(params[:id])
    # end
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
