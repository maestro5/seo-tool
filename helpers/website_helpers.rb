# ------------------------------
# Helpers for WebsiteController
# ------------------------------
module WebsiteHelpers
  def save_settings
    current_user.update storage: params['storage']
  end
end # WebsiteHelpers
