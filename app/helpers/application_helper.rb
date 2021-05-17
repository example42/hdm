module ApplicationHelper
  def flash_class(level)
    case level
      when 'notice' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
  end

  def format_path(path_data)
    tag_name, classes =
      if path_data[:key_present]
        [:b, nil]
      elsif path_data[:file_present]
        [:span, "text-dark"]
      else
        [:em, "text-muted"]
      end
    tag.send(tag_name, path_data[:path], class: classes)
  end

  def icon(name)
    path = asset_pack_path("media/bootstrap-icons/bootstrap-icons.svg")
    tag.svg(class: "bi", fill: "currentColor") do
      tag.use(href: "#{path}##{name}")
    end
  end

  def user_deletion_confirmation(user)
    if user == current_user
      'THIS IS YOUR ACCOUNT! Are you sure?'
    else
      'Are you sure?'
    end
  end
end
