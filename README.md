# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * specs pour subnodes
 * specs for treenode
 * Faut-il activer la recherche de pénalité dans tous les cas au niveau des sous-nodes?
 * Modifier munkres pour celui-ci: https://github.com/maandree/hungarian-algorithm-n3 ?

 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   poussée ? + éviter de construire tout si un node du dessus est déjà dans le hashtable (améliorer service)
 * Vérifier que notre A* est bien optimal (avec des tests !). Doit-il vraiment l'être ?
 * Changer code de munkres pour un n2 plutôt qu'un n3?
 * Try to optimize zone with zone_pos_to_level_pos and level_pos_to_zone_pos
