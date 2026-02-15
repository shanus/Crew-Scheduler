class SparklinesController < ApplicationController
  # The legacy sparklines gem is not compatible with modern Ruby/Rails.
  # This controller serves as a placeholder or could be updated to use chartjs-ror.
  # For now, it will return a blank image to avoid breaking front-end calls.

  def index
    # Placeholder for legacy sparkline generation
    # Recommend moving to JS-based charts (Chart.js via chartjs-ror) in the views.
    head :not_implemented
  end

  def show
    head :not_implemented
  end
end
