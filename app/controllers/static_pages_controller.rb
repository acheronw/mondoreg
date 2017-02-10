class StaticPagesController < ApplicationController

  before_action :authenticate_user!, only: [:hub]

  def home
  end

  def help
  end

  def hub

  end

end
