# -*- encoding : utf-8 -*-
class NotificationSystem::Save

  # Enregistre la notification dans la bd
  def self.perform(class_name, method_name, _values, owners)
    _values.is_a?(Array) ? values = _values : values = [_values]
    # Pour sauvagarder uniquement des string dans la bd
    values.map! do |value|
      if value.respond_to? :to_global_id
        value.to_global_id.to_s # AR objetc we encode it with GlobalID
      else
        value.to_s
      end
    end
    if owners.respond_to? :each
      owners.each do |user|
        Notification.create(class_name: class_name, method_name: method_name, values: values, user: user) if user.is_a? User
      end
    elsif owners.is_a? User
      Notification.create(class_name: class_name, method_name: method_name, values: values, user: owners)
    end
  end
end
