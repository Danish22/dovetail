class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if current_user.spaces.count < 1
      new_space_path
    else
      space_members_path(current_user.spaces.first)
    end
  end
end
