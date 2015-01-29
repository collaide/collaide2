# Permet de commenter un topic. c-a-d, répondre à une nouvelle discussion
# Comme pour le moment la seul chose à commenter est un topic et que rien
# d'autre n'est prévu à court ou moyen terme, la relation n'est pas polymorphic.
# De plus, cela facilite la création des discussions pour les groupes. CF ancienne version avec le bidouillage
class Group::Comment < ActiveRecord::Base

  # Pour le moment la seul chose à commenter est un topic
  belongs_to :topic, class_name: 'Group::Topic',touch: true # touch: true ===> fait un update sur le topic quand un nouveau commentaire est créé

  # Le seul à pouvoir créer des commentaire est User
  belongs_to :user

  # Par défaut les commentaire sont ordinnés par leur date de création
  default_scope -> {order('created_at ASC')}
end
