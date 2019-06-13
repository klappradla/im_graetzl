class ToolteilerController < ApplicationController


  def new_1
    @content = 'toolteiler' # Render Demo Partial
    render :template => '/toolteiler/form/create/new'
  end

  def new_2
    @content = 'address' # Render Demo Partial
    render :template => '/toolteiler/form/create/new'
  end

  def new_3
    @content = 'pricing' # Render Demo Partial
    render :template => '/toolteiler/form/create/new'
  end

  def new_4
    @content = 'insurance' # Render Demo Partial
    render :template => '/toolteiler/form/create/new'
  end


  def rent_1
    @content = 'login' # Render Demo Partial
    render :template => '/toolteiler/form/rent/show'
  end

  def rent_2
    @content = 'address' # Render Demo Partial
    render :template => '/toolteiler/form/rent/show'
  end

  def rent_3
    @content = 'payment' # Render Demo Partial
    render :template => '/toolteiler/form/rent/show'
  end

  def rent_4
    @content = 'summary' # Render Demo Partial
    render :template => '/toolteiler/form/rent/show'
  end


end
