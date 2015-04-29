# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * spec for "size" on hashtable
 * Dans penalties_service, on utilise IDA et on utilise penalties_service récursivement.
   Est-ce que l'un des deux ne serait pas suffisant ? Ne fait-on pas deux fois le travail ?
 * Faut-il vraiment garder box_zones_minus_1_box tel qu'il est ? Ou peut-on se satisfaire
   des sous-zones impliquant la dernière caisse poussée ?
 * Mieux calculer les zones dans penalties service
 * specs for treenode
 * Try to optimize zone with zone_pos_to_level_pos and level_pos_to_zone_pos
 * Si sous-ensemble de caisse provoque pénalité (infinie ou pas) pour toutes les
   sous-combinaisons possibles de goals, alors l'ajouter systématiquement à l'estimation de la
   méthode hongroise (c'est juste dans le cas où la pénalité n'est valable que
   pour certains goals que c'est plus difficile à mettre en place)

