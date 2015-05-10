# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * specs pour subnodes
 * Faut-il activer la recherche de pénalité dans tous les cas au niveau des sous-nodes?
 * Modifier munkres pour celui-ci: https://github.com/maandree/hungarian-algorithm-n3 ?

 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   poussée ? + éviter de construire tout si un node du dessus est déjà dans le hashtable (améliorer service)
