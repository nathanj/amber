require "../../../spec_helper"

module Amber::Controller
  describe Base do
    describe "#redirect_to" do
      context "when location is a string" do
        ["www.amberio.com", "/world"].each do |location|
          it "sets the correct response headers" do
            hello_controller = build_controller("")
            hello_controller.redirect_to location

            response = hello_controller.response

            response.headers["Location"].should eq location
          end
        end
      end

      context "when location is a Symbol" do
        context "when is :back" do
          context "and has a valid referer" do
            it "sets the correct response headers" do
              hello_controller = build_controller("/world")
              hello_controller.redirect_to :back

              response = hello_controller.response

              response.headers["Location"].should eq "/world"
            end
          end

          context "and does not have a referer" do
            it "raisees an error" do
              hello_controller = build_controller("")

              expect_raises Exceptions::Controller::Redirect do
                hello_controller.redirect_to :back
              end
            end
          end
        end

        context "when is an action" do
          hello_controller = build_controller("/world")
          hello_controller.redirect_to :world

          response = hello_controller.response

          response.headers["Location"].should eq "/world"
        end
      end
    end
  end
end
