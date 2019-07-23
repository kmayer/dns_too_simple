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
    end
  end
end
