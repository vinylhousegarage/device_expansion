class ErrorsController < ApplicationController
  def not_found
    Rails.logger.debug "Not found action called with path: #{request.fullpath}"
    render :not_found
  end
end
