# frozen_string_literal: true
class HomeController < ApplicationController
  def check
    val = ActiveRecord::Base.connection.execute('select 1+2 as val').first['val']
    render text: "1+2=#{val}"
  end
end
