# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * A*: do we *really* need open and closed nodes? Don't think so since we move by steps of 1
   and waiting list is sorted by smaller f and smaller h (= bigger g)
 * specs for treenode
 * Si sous-ensemble de caisse provoque pénalité (infinie ou pas) pour toutes les
   sous-combinaisons possibles de goals, alors l'ajouter systématiquement à l'estimation de la
   méthode hongroise (c'est juste dans le cas où la pénalité n'est valable que
   pour certains goals que c'est plus difficile à mettre en place)
 * Specs for penalties (before writing code)
