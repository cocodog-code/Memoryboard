require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "#home" do 
    #200レスポンスが返ってきているか？
    it "returns a 200 response" do
      get root_url
      expect(response).to have_http_status "200"
    end
  end
end
