class SearchController < ApplicationController
  def index
    if params[:q]

      searchterm = params[:q]
      page = params[:page] || 1
      label = ''
      sort = ''

      if (params[:label] && params[:label] != 'all')
        label = " more:pagemap:document-type:" + params[:label]
      end

      if (params[:label] && params[:label] == 'rooms')
        label = " more:pagemap:document-type:room_offer OR more:pagemap:document-type:room_demand"
      end

      if params[:label] == 'meeting'
        #sort = 'date:startDate:d'
      end

      @results = GoogleCustomSearchApi.search(searchterm + label, sort: sort, page: page, num:9, as_sitesearch: params[:as_sitesearch])

    end
  end
end
