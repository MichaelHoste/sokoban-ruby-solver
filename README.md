# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   (et pour éliminer directement tous les sous-noeuds qui ont déjà été analysés ?)
 * Créer fichier log par solver.
 * Paramétriser sub_nodes et pénalités pour définir le nombre de caisses qu’on veut.
   poussée ? + éviter de construire tout si un node du dessus est déjà dans le hashtable (améliorer service)
 * should we search for penalties in every sub_node?
 * Should we update munkres for this one? https://github.com/maandree/hungarian-algorithm-n3
 * Tester une vraie situation en JRuby pour comparer les perfs
