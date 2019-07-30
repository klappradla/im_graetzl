class ToolteilerController < ApplicationController

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
