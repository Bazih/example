module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def cache_key_for_user(model, description)
    user_id = user_signed_in? ? current_user.id : 0
    "#{model.to_s.pluralize}/#{description}-#{model.id}-for-user-#{user_id}"
  end
end
