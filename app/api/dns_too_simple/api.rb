module DNSTooSimple
  class API < Grape::API
    format :json
    prefix "/api"

    resource :zones do
      desc "Return a zone"
      params do
        requires :id, type: Integer, desc: "Zone ID"
      end
      route_param :id do
        get do
          Zone.find(params[:id])
        end
      end
    end
  end
end
