class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "MondoCon registration site. Construction under progress"
  end

end
