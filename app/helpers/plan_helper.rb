module PlanHelper
  def free_plan
    Billing::Plan::FREE
  end

  def pro_plan
    Billing::Plan::PRO
  end
end
