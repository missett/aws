resource "aws_budgets_budget" "monthly_total_cost" {
  name = "monthly_total_cost"
  budget_type = "COST"
  limit_amount = "10"
  limit_unit = "USD"
  time_unit = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold = 100
    threshold_type = "PERCENTAGE"
    notification_type = "FORECASTED"
    subscriber_email_addresses = ["ryan.missett@gmail.com"]
  }
}
