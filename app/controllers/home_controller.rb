class HomeController < ApplicationController
  def index
  end

  def check
    val = ActiveRecord::Base.connection.execute('select 1+2 as val').first['val']
    render text: "1+2=#{val}"
  end
end
