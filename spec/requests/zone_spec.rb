require "rails_helper"

RSpec.describe "Zone", :type => :request do
  context "GET /api/zones/:id" do
    it "returns a zone" do
      zone = Zone.create(domain_name: "example.com")

      get_json "/api/zones/#{zone.to_param}"

      expect(response.body).to eq(zone.to_json)
    end

    it "returns not_found" do
      get_json "/api/zones/-1", "404"
    end
  end

  context "GET /api/zones" do
    it "returns *all* zones" do
      zones = [Zone.create!(domain_name: "example.com")]

      get_json "/api/zones"

      expect(response.body).to eq(zones.to_json)
    end
  end

  context "POST /api/zones" do
    it "creates a zone" do
      zone = { domain_name: "example.com" }

      post_json "/api/zones", zone

      expect(parsed_json).to include(zone.as_json)
      expect(Zone.find(parsed_json["id"])).to be_a(Zone)
    end

    it "will not create a duplicate zone" do
      zone = Zone.create(domain_name: "example.com")

      post_json("/api/zones", zone, "422")
    end
  end

  context "PUT /api/zones/:id" do
    it "will update an existing zone" do
      zone = Zone.create(domain_name: "example.com")
      update = { domain_name: "example.org" }

      put_json "/api/zones/#{zone.to_param}", update, "200"

      expect(parsed_json).to include(update.as_json)
    end

    it "will handle not_found" do
      update = { domain_name: "example.org" }

      put_json("/api/zones/-1", update, "404")
    end
  end

  context "DELETE /api/zones/:id" do
    it "will destroy the object" do
      zone = Zone.create(domain_name: "example.com")

      delete_json "/api/zones/#{zone.to_param}"

      expect(Zone.find_by_id(zone.id)).to be_nil
    end

    it "will handle not_found" do
      delete_json "/api/zones/-1", "404"
    end
  end
end