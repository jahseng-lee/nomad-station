class IssuesController < ApplicationController
  def index
    raise NotImplementedError, "TODO"
  end

  def show
    raise NotImplementedError, "TODO"
  end

  def create
    @issue = Issue.new(create_params)

    authorize(@issue)

    respond_to do |format|
      format.turbo_stream do
        unless @issue.save
          # TODO create a issues/create.turbo_stream.erb which:
          #      * removes the modal
          #      * inserts an alert
          #        * can do this by making the existing alerts a turbo
          #          frame and refreshing that; OR
          #        * creating a new frame and just inserting
          render turbo_stream: turbo_stream.append(
            "modal-flash-error",
            partial: "issues/alert_error_create"
          )
          return
        end
      end
    end
  end

  def update
    raise NotImplementedError, "TODO"
  end

  private

  def create_params
    params.require(:issue).permit(
      :reporter_id,
      :entity_id,
      :entity_type,
      :additional_information,
      :issue_type,
      :body
    )
  end
end
