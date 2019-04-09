class TeamsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_team, only: %i[show edit update destroy change_owner]
  before_action :set_team, only: %i[show edit update destroy]
  # before_action :require_owner, only: %i[edit change_owner]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: 'チーム作成に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'チーム更新に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'チーム削除に成功しました！'
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def change_owner
    # binding.pry
    @team = Team.find(params[:para2])
    @team.owner_id = params[:para1].to_i
    @team.update(team_params)
    # binding.pry
    TeamMailer.team_mail(@team).deliver
    # @team.owner_id.update(params[:para1])
    redirect_to team_path(params[:para2]), notice: 'リーダーを変更しました！'

    # if @team.update(owner_param)
    #   tedirect_to @team, notice: '権限移動'
    # else
    #   render @team
    # end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end

  # def owner_param
  #   params.permit(:owner_id)
  # end
  #
  # def requirere_owner
  #   team = Team.frendly.find(params[:id])
  #   redirect_to team_path(team.id), notice: "権限なし" unless current_user.id == team.owner_id
  # end

end
