class GameController < ApplicationController
  def add
  end
  def insert
    added = Game.create_games "#{params[:results]}
    
    #{params[:results_m1lhao]}
    "
    if added > 0
      gflash :success => "A total of #{added} games were added with success"
      redirect_to root_path
      return
    elsif added == 0
      gflash :notice => "No games were found in the input"
    else
      gflash :error => "Error creating one of the games"
      return
    end
    render :add
  end
end
