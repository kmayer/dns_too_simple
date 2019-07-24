module DNSTooSimple
  class API < Grape::API
    format :json
    prefix "/api"
    rescue_from ActiveRecord::RecordNotFound do |e|
      error!(e, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!(e, 422)
    end

    resource :zones do
      desc "Return a zone"
      params do
        requires :id, type: String, desc: "Zone ID"
      end
      route_param :id do
        get do
          Zone.find(params[:id])
        end
      end

      desc "Return all zones"
      get do
        Zone.all
      end

      desc "Create a zone"
      params do
        requires :domain_name, type: String, desc: "Domain name"
      end
      post do
        Zone.create!({domain_name: params[:domain_name]})
      end

      desc "Update a zone"
      params do
        requires :id, type: String, desc: "Zone ID"
        optional :domain_name, type: String, desc: "Domain name"
      end
      route_param :id do
        put do
          zone = Zone.find(params[:id])
          zone.update!(domain_name: params[:domain_name])
          zone
        end
      end

      desc "Destroy a zone"
      params do
        requires :id, type: String, desc: "Zone ID"
      end
      route_param :id do
        delete do
          zone = Zone.find(params[:id])
          zone.destroy!
        end
      end

      route_param :zone_id, type: String do
        resource :records do
          desc "Return a zone record"
          params do
            requires :id, type: String, desc: "Record ID"
          end
          route_param :id do
            get do
              zone = Zone.find(params[:zone_id])
              zone.records.find(params[:id])
            end
          end

          desc "Returns all zone records"
          get do
            zone = Zone.find(params[:zone_id])
            zone.records
          end

          desc "Create a zone record"
          params do
            requires :ttl, type: Integer, desc: "Time To Live (in seconds)"
            requires :name, type: String, desc: "Name"
            requires :type, type: String, desc: "Record type", values: %w[A CNAME]
            optional :ipaddr, type: String, desc: "IPV4 address"
            optional :domain_name, type: String, desc: "domain_name"
          end
          post do
            zone = Zone.find(params[:zone_id])
            zone.records.create!(params)
          end

          desc "Update a zone record"
          params do
            requires :id, type: String, desc: "Record ID"
            requires :ttl, type: Integer, desc: "Time To Live (in seconds)"
            requires :name, type: String, desc: "Name"
            requires :type, type: String, desc: "Record type", values: %w[A CNAME]
            optional :ipaddr, type: String, desc: "IPV4 address"
            optional :domain_name, type: String, desc: "domain_name"
          end
          route_param :id do
            put do
              zone = Zone.find(params[:zone_id])
              record = zone.records.find(params[:id])
              record.update!(params)
              record
            end
          end

          desc "Destroy a record"
          params do
            requires :id, type: String, desc: "Record ID"
          end
          route_param :id do
            delete do
              zone = Zone.find(params[:zone_id])
              record = zone.records.find(params[:id])
              record.destroy!
            end
          end
        end
      end
    end
  end
end
