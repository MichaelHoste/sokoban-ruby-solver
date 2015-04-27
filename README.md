# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * Mieux calculer les zones dnas penalties service
 * Utiliser (corriger?) file dans penalties_service pour d'abord calculer tous les petits puis tous les grands sous-noeuds
 * Mettre dans un hash les noeuds pour lesquels les pénalités ont déjà été appliquées (utiliser hashtable du solver?)
 * specs for treenode
 * Try to optimize zone with zone_pos_to_level_pos and level_pos_to_zone_pos
 * Si sous-ensemble de caisse provoque pénalité (infinie ou pas) pour toutes les
   sous-combinaisons possibles de goals, alors l'ajouter systématiquement à l'estimation de la
   méthode hongroise (c'est juste dans le cas où la pénalité n'est valable que
   pour certains goals que c'est plus difficile à mettre en place)

