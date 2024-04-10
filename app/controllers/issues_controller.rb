class IssuesController < ApplicationController
  def index
    authorize(Issue)

    @issues = Issue.unresolved
  end

  def create
    @issue = Issue.new(create_params)
    authorize(@issue)

    respond_to do |format|
      format.turbo_stream do
        unless @issue.save
          render turbo_stream: turbo_stream.append(
            "modal-flash-error",
            partial: "issues/alert_error_create"
          )
          return
        end
      end
    end
  end

  def update # a.k.a. "Resolve"
    # Weird update - just resolves the issue.
    # The policy _should_ check the user is admin. Assume that no admins
    # are trying to maliciously resolve all issues
    @issue = Issue.find(params[:id])
    authorize(@issue)

    @issue.update!(resolved: true)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "issue-#{@issue.id}",
          partial: "issues/alert_success_resolve"
        )
      end
    end
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
