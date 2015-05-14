# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * Créer deux listes : processed et waiting. Utiliser processed? au niveau du parent,
   utiliser (processed? || waiting?) au niveau des enfants
 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   (et pour éliminer directement tous les sous-noeuds qui ont déjà été analysés ?)
 * Créer fichier log par solver.
 * Paramétriser sub_nodes et pénalités pour définir le nombre de caisses qu’on veut.
 * should we search for penalties in every sub_node?
 * Should we update munkres for this one? https://github.com/maandree/hungarian-algorithm-n3
 * Tester une vraie situation en JRuby pour comparer les perfs
