class UsersController < ApplicationController
  before_action :require_login, only: [:progress]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to problems_path
    else
      render :new
    end
  end

  def profile
  end

  def edit
  end

  def destroy
  end

  def progress
    @data = Problem.ranks.keys.map do |rank|
      {
        '正解' => current_user.solved_problems.where(rank: rank).count,
        '未正解' => Problem.where(rank: rank).count,
      }
    end
  end

  def recommend
  end

  private

  def user_params
    # binding.pry
    params.require(:user).permit(:name, :email, :password)
  end
end
