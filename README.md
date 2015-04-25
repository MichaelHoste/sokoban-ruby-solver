# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * improve boxes_to_goals_minimal_cost to integrate penalties
 * specs for treenode
 * Try to optimize zone with zone_pos_to_level_pos and level_pos_to_zone_pos
 * Si sous-ensemble de caisse provoque pénalité (infinie ou pas) pour toutes les
   sous-combinaisons possibles de goals, alors l'ajouter systématiquement à l'estimation de la
   méthode hongroise (c'est juste dans le cas où la pénalité n'est valable que
   pour certains goals que c'est plus difficile à mettre en place)
 * Specs for penalties (before writing code)

