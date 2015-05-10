# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * remplacer read_pos et write_pos par des inlines partout
 * Créer fichier log par solver.
 * Paramétriser sub_nodes et pénalités pour définir le nombre de caisses qu’on veut.
 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   poussée ? + éviter de construire tout si un node du dessus est déjà dans le hashtable (améliorer service)
 * should we search for penalties in every sub_node?
 * Should we update munkres for this one? https://github.com/maandree/hungarian-algorithm-n3

