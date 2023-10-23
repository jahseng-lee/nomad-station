class VisaInformationController < ApplicationController
  def show
    @location = Location.find(params[:location_id])
    @country = @location.country

    # TODO move this renderer to application_controller? Or new specialty controller?
    renderer = Redcarpet::Render::HTML.new(render_options = {})
    @markdown = Redcarpet::Markdown.new(renderer, extensions = {})
  end

  def edit
    @location = Location.find(params[:location_id])
    @country = @location.country

    authorize(@location, :edit?)
  end
end
