class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: t(:under_construct)

    # render html: "MondoCon registration site. Construction under progress"
  end

end
