# [Collaide](https://beta.collaide.com)

Collaide est une plateforme pour faciliter le travail de groupe

## Motivations
Le besoin de créer une telle plateforme vient du constat qu'il n'existe aucun outils open-source, gratuits et libre pour faciliter le travail en groupe. Nous sommes étudiant et pour chaque projet de groupe, nous communiquons par e-mail ou facebook et échangeons les fichiers(rapports, présentations, etc) par Dropbox, e-mail, google-doc suivant les envies et les groupes.

> Et alors, où est le problème ?

Le problème est que les discussions par e-mail ne sont pas archivées, se perdent dans la masse d'e-mails échangés quotidienement et ne sont pas efficace pour les discussions longues. Les discussions sur Facebook favorisent les échanges courts (pas de mise en forme, pas de pagination, pas de regroupement par sujet, tout est dans une seule page).

Pour l'échange de fichiers par e-mail, il faut le réenvoyer pour chaque modifications, la taille du fichier est limitée. Il n'y a pas de stcokage centralisé.

En utilisant une plateforme telle que Facebook, Dropbox, GoogelDoc, etc, nous avons un contrôle limité sur nos données et nous ne savons pas à quelle fin elles sont utilisées. Ces entreprises et ces serveurs sont situés presque tous aux États-Unis ce qui ne nous donne presque aucun droit. De plus leur fonctionnement est opaque et ne savons pas ce qu'il se passe derrière. Le risque de perdre le contrôle sur nos données gérées par ces services existe, y compris pour les fichiers qui s'y trouvent.

> Et la solution ?

Notre solution est de proposer une plateforme dédiée au travail de groupe open-source, gratuite et libre. Ainsi, n'importe quel développeur peut connaître son fonctionement et y apporter son savoir-faire. Pour un contrôle total, n'importe qui peut faire tourner sa propre version de collaide sur son serveur et ainsi avoir le plus grand contrôle sur ses données. N'importe quel utilisateur peut utiliser notre service gratuitement pour [créer un groupe](https://beta.collaide.com/fr/groups/new) et commencer à travailler.

## Version beta
Cette version beta est développée activement. Cela signifie que des bugs peuvent survenir et que des grandes améliorations sont attendues au cours des ces prochaines semaines.

Si vous voulez contribuer à améliorer et développer collaide, lisez la suite.

## Bugs, question, amélioration
Postez un message sur [github](https://github.com/collaide2/collaide/issues/new) et ajouter le tag `bug` si vous avez rencontré un bug en utlisant collaide, la `feature` si vous suggérez une amélioration et `question` si vous avez une question.

Pour signaler un bug, indiquer:
 * l'heure et la date à laquelle il s'est produit
 * idéalement une capture d'écran
 * Comment le reproduire

##Déscription
collaide.com est un site web offrant différents services aux étudiants. Actuellement il est possible de télécharger et mettre à disposition des documents scolaires, acheter et vendre des livres scolaires d'occasion et créer des groupes de travail.
### Échange de documents scolaires
C'est actuellement le service le plus utilisé. Il est possible de rechercher, télécharger et mettre des documents scolaires importants. Par exemple, rapport de projet, travail de maturité, de séminaire, dosssier, etc. Pour le moment plus de 100 documents sont mis à disposition.
### Vente et achat de livres scolaires
Permet d'acheter et vendre des livres d'occasions. Par la suite, il est prévu de pouvoir poster des annonces pour d'autres domaines. Appartements, échange de service, etc.
### Groupes de travails
Tout nouveau service! Il permet à des étudiants de discuter et échanger des fichiers dans un espace privé. C'est le service qui va la plus vite évoluer avec comme premiers objectifs la possibilité de garder un historique des modifications des fichiers, éditer, commenter des fichiers.

Par la suite, il est aussi prévu de pouvoir créer d'autres type de groupe. Groupes publics, présentation d'association d'étudiants, de faculté, etc.
### Plus
Vous avez des idées ? des suggestions ? Postez une [suggestion](https://github.com/collaide/collaide/issues/new) ou rejoinez-nous pour coder directement votre idée

Nous-même en avons encore pleins, mais pas le temps de tout faire

##Recherche

Nous recherchons des personnes désirueses de nous aider :
* traducteur français-anglais -> trouvé
* traducteur français-allemand -> trouvé
* traducteur français-italien
* plusieurs développeurs Web dans les domaines suivant (un seul est c'est déjà cool): HTML/CSS, Javascript, Ruby/RoR
* une personne responsable de la communication (social marketing, réferencement, écriture de textes, etc)

##Organisation

collaide.com a été développé durant notre temps libre. Le coût des serveurs et autre et payé de notre poche. Si vous voulez nous soutenir finacièrement, [contactez-nous](http://www.collaide.com/fr/contactez-nous)

Nous avons séparé le travail en plusieurs modules indépendants l'un de l'autre. Ainsi, chacun peut travailler sur le ou les modules qui lui conviennent sans devoir comprendre l'ensemble du site. Pour l'instant, il y a 5 modules:

* Documents, gestion de documents scolaires.
* Annonces, Vendre des livres, en acheter. Par la suite, possibilité de poster des annonces pour d'autres choses
* Groupes, échanger entre étudiants. Pour l'instant uniquement les groupes de travails sont implémentés, mais d'autres types de groupe viendront par la suite.
* Utilisateurs, gestion des utilisateurs, messagerie privé et notification
* Activités, gestion des activités du site. Chaque utilisateur peur configurer quelles activités il veut voir et chaque modèle possède ses propres activités.

##Languages et outils

Pour le versioning:
* git

Nous utilisons les languages suivant :
* Ruby
* Haml/ERB
* HTML/CSS
* Coffeescript
* Saas

Les base de données sont en :
* postgresql
* mysql (indexation)


Nous utilisons comme framework :
* Ruby on Rails
* Foundation

Liste des gems Ruby les plus importantes :
* devise
* ancestry
* cancan
* globalize3
* active-admin
* i18n
* i18n-routing

consulter le Gemfile pour une liste complète

Pour les tests, nous utilisons:
* Rspec
* cucumber
* FactoryGirl
* guard

##Auteurs
Yves Baumann et Numa de Montmollin. [les auteurs](http://www.collaide.com/fr/a-propos)

License Collaide
-------
Copyright (c) 2009-2014 All rights reserved.

- Fondateur : Yves Baumann
- Cofondateur : Numa de Montmollin 
