module Billing
  # Displays available subscription plans for the billing page
  class PlansController < ApplicationController
    def index
      @free_plan = Billing::FreePlan.decorate
      @pro_plan = Billing::ProPlan.decorate
    end
  end
end
