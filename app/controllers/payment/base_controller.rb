class Payment::BaseController < ApplicationController
  before_action :authenticate_user!

  # This view will have only a header and the embedded MyPOS SDK will be included in that
  # So it will be accessible in any view that belongs to a controller that is derived from this controller
  layout "payment/payment"

  skip_before_action :authenticate_user!, only: [:notify]

end
