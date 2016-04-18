module ApplicationHelper
  def form_group_tag(errors)
    if errors.any?
       'form-group has-error'
    else
       'form-group'
    end
  end
end