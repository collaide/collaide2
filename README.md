# [Collaide](https://beta.collaide.com)

Collaide est une plateforme Web pour faciliter le travail de groupe. Nous implémentons une façon moderne et conviviale de mener des discussions, de stocker et de partager des fichiers avec les membres d'un groupe. De plus, nous facilitons la gestion et la création de groupes avec une interface claire et intuitive.

## Motivations
Le besoin de créer une telle plateforme vient du constat qu'il n'existe aucun outils open-source, gratuits et libre pour faciliter le travail en groupe. Nous sommes étudiant et pour chaque projet de groupe, nous communiquons par e-mail ou Facebook et échangeons les fichiers(rapports, présentations, etc) par Dropbox, e-mail, GoogleDoc suivant les envies et les groupes.

> Et alors, où est le problème ?

Le problème est que les discussions par e-mail ne sont pas archivées, se perdent dans la masse d'e-mails reçus quotidienement et deviennent peu lisibles pour les longues discussions avec beaucoup de réponses. Les discussions sur Facebook favorisent les échanges courts. Il n'y a pas de mise en forme, pas de pagination, pas de regroupement par sujet et tout est dans une seule page.

Pour l'échange de fichiers par e-mail, il faut le réenvoyer pour chaque modifications, la taille du fichier est limitée et il n'y a pas de stcokage centralisé.

En utilisant une plateforme telle que Facebook, Dropbox, GoogelDoc, etc, nous avons un contrôle limité sur nos données et nous ne savons pas à quelle fin elles sont utilisées. Ces entreprises et ces serveurs sont presque tous situés aux États-Unis ne nous donnant quasiment aucun droit. De plus leur fonctionnement est opaque et nous ne savons pas ce qu'il se passe derrière. Le risque de perdre le contrôle sur nos données gérées par ces services existe, y compris pour les fichiers qui s'y trouvent.

> Et la solution ?

Notre solution est de proposer une plateforme dédiée au travail de groupe open-source, gratuite et libre. Ainsi, n'importe quel développeur peut connaître son fonctionement et y apporter son savoir-faire. Pour un contrôle total, n'importe qui peut faire tourner sa propre version de collaide sur son serveur et ainsi avoir le plus grand contrôle sur ses données. N'importe quel utilisateur peut utiliser notre service gratuitement pour [créer un groupe](https://beta.collaide.com/fr/groups/new) et commencer à travailler.

## Version beta
Cette version beta est développée activement. Cela signifie que des bugs peuvent survenir et que des grandes améliorations sont attendues au cours des ces prochaines semaines.

Si vous voulez contribuer à améliorer et développer collaide, lisez la suite.

## Contribuer

Pour connaître comment notre projet est organisé, quels outils et technologies nous utilisons, lire la section [organisation](#organisation)

### Bugs, question, amélioration
Postez un message sur [github](https://github.com/collaide2/collaide/issues/new) et ajouter le tag `bug` si vous avez rencontré un bug en utlisant collaide, `feature` si vous suggérez une amélioration et `question` si vous avez une question.

Pour signaler un bug, indiquer:
 * l'heure et la date à laquelle il s'est produit
 * idéalement une capture d'écran
 * Comment le reproduire

### Graphisme et design
Nous sommes à la recherche d'une personne pour nous proposer une belle page
de présentation pour la page d'accueil et pour la page d'accueil d'un
groupe.

Actuellement, le design est trop sobre et manque de vie, nous acceptons
n'importe quelle propositions pour l'améliorer

Il nous manque également certaines icônes:
* symbole pour afficher le nombre de notifications (genre un nombre dans
  un cercle rouge)
* icône pour les notification
* etc

Un cool logo est toujours manquant.

N'importe quel autre proposition pour améliorer le design et le
graphisme du site

### Développer
Pour contribuer au développement du code source:
1. Faire un fork du projet [github](https://github.com/collaide/collaide2)
2. Choisir un bug à corriger ou une amélioration à effectuer.
3. Ouvrir une issue sur Github pour dire ce que vous faites (comme ça le
   travail n'est pas fait à double et on peut discuter de la manière
   optimale de le faire)
2. Effectuer vos modifications
3. Mettre à jour le numéro de version, CF [Organisation](#Organisation)
4. Ajouter son nom dans le fichier CONTRIBUTORS si il n'y est pas déjà
3. Soumettre une pull request sur la branche `develop`

#### Environnement de développement
L'environnement est celui d'un projet Rails classique. Cela signifie
d'avoir Ruby > 2.0 installé et PostgreSQL avec une base de donnée du nom
de collaide-dev

Normalement, si tout ce passe bien, la première fois vous faites:
1. `git clone <votre repo de collaide>`
2. `cd <votre repo de collaide> && bundle install`
3. Démarage de PostgreSQL
4. `rake db:migrate populate:all` (`populate:all` permet de créer des
   fausses données)
3. `rails s`

Nous utilisons Rubymine comme IDE.

#### Guidelines
* Pour Ruby, nous nous réferrons à la Guideline de [Github]()
* Pour Rails, nous nous réferrons à la Guideline de [Github]()
* Pour collaide au [wiki]()

### Financièrement
collaide a été développé durant notre temps libre. Le coût des serveurs et autre et payé de notre poche. Si vous voulez nous soutenir finacièrement, [contactez-nous](http://www.collaide.com/fr/contactez-nous)

## Organisation

### Frameworks et langages
Le projet est développé avec le framework [Ruby on
Rails](rubyonrails.org). Pour le front-end,
[Foundation](http://zurb.foundation.com/docs) est utilisé comme
framework HTML/Css et [AngularJS](http://angularjs.org) comme framework
Javascript. Pour les vues nous utilisons le langage HAML qui permet
d'écrie moins de code. Mais ERB peut aussi être utilisé sans problème.
Le Css est généré à partir de SaaS et la Javascript à partir de
CoffeScript.

Pour l'organisation du Javascript, suivre les conventions et la façon de
faire définis par AngularJS.

### Origine du code
Une bonne partie du code vient du répertoire Github d'une ancienne
[version](https://github.com/collaide/collaide). Nous avons créé un
nouveau répertroire pour repartir sur de bonnes bases et parce que nous
avons quelque peu changé d'objectis et réduit nos ambitons.

### Base de donnée
La base de donnée est entièrement sous PostgreSQL pour le moment. Mais
il est prévu de passer sous redis pour les job en background et
d'utiliser elasticsearch comme moteur de recherche.

### Versioning
Le fichier VERSION indique à quelle version se trouve collaide. Pour
décider du numéro de version, nous utilsons trois chiffres comme suit:
* Premier chiffre: Un changement de version majeur
* Deuxième: Une nouvelle fonctionalité, une amélioration importante
* Troisième: Corrections de bugs et améliorations mineures

Le projet est sous contrôle de version avec Git. Il comprend deux
branches majeures. `master` qui est la branche avec le code en ligne de la version actuelle et `develop` qui contient le code en cours de développement. Une fois que nous jugeons le code assez mature dans la branche `develop`, nous la fusionons avec `master`. Nous utilisons git flow pour faciliter le travail.

### Roadmap
Dans le wiki, la page [Roadmap]() définie ce qu'il est prévu de faire pour
chaque version. Une fois que toutes les fonctionalités sont cochées pour
une version, nous la mettons en ligne et la fusionons avec la branche master.


## Auteurs
Yves Baumann et Numa de Montmollin. [les auteurs](http://www.collaide.com/fr/a-propos)

License Collaide
-------
Copyright (c) 2009-2014 All rights reserved.

- Fondateur : Yves Baumann
- Cofondateur : Numa de Montmollin

