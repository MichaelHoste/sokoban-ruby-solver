# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

![Build Status](https://www.codeship.io/projects/6e6488b0-b2b1-0132-f32a-2e477b22f50d/status)


## Todo

 * Améliorer la sortie standard (total_tries, nombre d'itérations pour chaque niveau de caisses, etc.)
 * Accélérer les pénalités infinies !
 * Ajouter plus de tests pour NodeChildrenToGoalsService + refactorer
 * Faut il recouper les arbres entiers parents à chaque nouvelle pénalité trouvée pour gagner du temps ?
   (lors de l'analyse du premier noeud parent, on a très vite une pénalité qui permettrait de l'invalider)
 * Il faudrait éviter de prendre en compte un noeud enfant qui a déjà été ouvert dans une autre itération
   de A (par contre la solution ne sera plus bonne, que faire ?)
 * PISTE : Il y a des états inutiles qu'on veut supprimer. Souvent ce sont les états qui ont les
   mêmes pusher_zones (et nombre de caisses) et qui représentent au final la même situation.
   Une fois que la téléportation des caisses vers les goals sera faite, modifier la table de hashage
   (fonction de hashage et include?) pour éliminer les états redondants.
 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   (et pour éliminer directement tous les sous-noeuds qui ont déjà été analysés ?)
 * Paramétriser sub_nodes et pénalités pour définir le nombre de caisses qu’on veut.
 * Définir variables globales pour activer/désactiver certains services
 * should we search for penalties in every sub_node?
 * Should we update munkres for this one? https://github.com/maandree/hungarian-algorithm-n3
 * Tester une vraie situation en JRuby pour comparer les perfs
 * Adopt some services to multi-threads computing (GPU?) or C++, or both
