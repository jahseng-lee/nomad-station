require 'rails_helper'

RSpec.describe "Citizenships", type: :request do
  let(:signed_in_user) { create(:user) }
  before do
    sign_in signed_in_user
  end

  describe "GET #show" do
    context "with multiple users in the system" do
      let!(:other_user) { create(:user) }

      it "sets up the signed_in user with a random client reference id" do
        get choose_plan_path

        signed_in_user.reload
        other_user.reload

        expect(signed_in_user.last_checkout_reference).not_to be_nil
        expect(other_user.last_checkout_reference).to be_nil
      end
    end

    context "if the user already has a linked stripe accont" do
      before do
        signed_in_user.update!(stripe_customer_id: "foobar")
      end

      it "redirects to the profile page" do
        get choose_plan_path

        expect(response.status).to eq 302
        expect(response.location).to eq profile_url
      end
    end
  end
end
