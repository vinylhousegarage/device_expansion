class ErrorsController < ApplicationController
  def not_found
    Rails.logger.warn('404 Not Found')
    redirect_with_alert(root_path, not_found)
  end
end
