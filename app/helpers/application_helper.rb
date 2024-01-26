module ApplicationHelper
  def flash_class(level)
    bootstrap_alert_class = {
      "success" => "alert-success",
      "notice" => "alert-info",
      "alert" => "alert-danger",
    }
    bootstrap_alert_class[level]
  end
end
