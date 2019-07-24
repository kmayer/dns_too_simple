require "rails_helper"

RSpec.describe "Record", :type => :request do
  let!(:zone) { Zone.create!(domain_name: "example.com") }

  context "GET /api/zones/:zone_id/records/:id" do
    it "will return a zone's A record" do
      record = zone.records.create!(name: "host", ipaddr: "172.20.10.2", type: "A", ttl: 3600)

      get_json "/api/zones/#{zone.to_param}/records/#{record.to_param}"

      expect(response.body).to eq(record.to_json)
    end

    it "will return a zone's CNAME record" do
      record = zone.records.create!(name: "host", domain_name: "host.example.org.", type: "CNAME", ttl: 3600)

      get_json "/api/zones/#{zone.to_param}/records/#{record.to_param}"

      expect(response.body).to eq(record.to_json)
    end

    it "returns not_found" do
      get_json "/api/zones/#{zone.to_param}/records/-1", "404"
    end
  end

  context "GET /api/zones/:zone_id/records" do
    it "will return *all* of zone's records" do
      records = [zone.records.create!(name: "host", ipaddr: "172.20.10.2", type: "A", ttl: 3600)]

      get_json "/api/zones/#{zone.to_param}/records"

      expect(response.body).to eq(records.to_json)
    end
  end

  context "POST /api/zones/:zone_id/records" do
    it "creates a record" do
      record = { name: "host", ipaddr: "172.20.10.2", type: "A", ttl: 3600}

      post_json "/api/zones/#{zone.to_param}/records", record

      expect(parsed_json).to include(record.as_json)

      expect(Record.find(parsed_json["id"])).to be_a(A)
    end
  end

  context "PUT /api/zones/:zone_id/records/:id" do
    it "will update a zone record" do
      record = zone.records.create!({ name: "host", ipaddr: "172.20.10.2", type: "A", ttl: 3600}.as_json)
      update = {name: "myhost", ipaddr: "172.20.10.1", type: "A", ttl: 3600}.as_json

      put_json "/api/zones/#{zone.to_param}/records/#{record.to_param}", update, "200"

      expect(parsed_json).to include(update.as_json)
    end

    it "will handle not_found" do
      update = {name: "myhost", ipaddr: "172.20.10.1", type: "A", ttl: 3600}.as_json

      put_json "/api/zones/#{zone.to_param}/records/-1", update, "404"
    end
  end

  context "DELETE /api/zones/:zone_id/records/:id" do
    it "will destroy the object" do
      record = zone.records.create!({ name: "host", ipaddr: "172.20.10.2", type: "A", ttl: 3600}.as_json)

      delete_json "/api/zones/#{zone.to_param}/records/#{record.to_param}"

      expect(Record.find_by_id(record.id)).to be_nil
    end

    it "will handle not_found" do
      delete_json "/api/zones/#{zone.to_param}/records/-1", "404"
    end

    it "will destroy Zone dependent records" do
      record = zone.records.create!(name: "host", ipaddr: "172.20.10.2", type: "A", ttl: 3600)

      delete_json "/api/zones/#{zone.to_param}"

      expect(Record.find_by_id(record.id)).to be_nil
    end
  end
end