# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * Eviter la boucle supplémentaire pour faire << en utilisant un concat (vérifier la vitesse)
 * spec for "size" on hashtable
 * Faut-il vraiment garder box_zones_minus_1_box tel qu'il est ? Ou peut-on se satisfaire
   des sous-zones impliquant la dernière caisse poussée ?
 * Changer code de munkres pour un n2 plutôt qu'un n3?
 * specs for treenode
 * Try to optimize zone with zone_pos_to_level_pos and level_pos_to_zone_pos
 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   poussée ?
