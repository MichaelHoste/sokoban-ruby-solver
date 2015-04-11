# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * Use hashs correctly to optimize open_node time (remove node.id and find a better way (manual hashtable?))
 * Si sous-ensemble de caisse provoque pénalité (infinie ou pas) pour toutes les
   sous-combinaisons possibles de goals, alors l'ajouter systématiquement à l'estimation de la
   méthode hongroise (c'est juste dans le cas où la pénalité n'est valable que
   pour certains goals que c'est plus difficile à mettre en place)
 * A*
 * Specs for penalties (before writing code)
 * Zone.zone is weird, change to Zone.number
