RSpec.describe "DNSTooSimple::API", :type => :request do
  context "GET /zones/:id" do
    it "returns a zone" do
      zone = Zone.create(domain_name: "example.com")
      get "/api/zones/#{zone.to_param}"
      expect(response.body).to eq(zone.to_json)
    end
  end
end