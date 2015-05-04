# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * Eviter la boucle supplémentaire pour faire << en utilisant un concat (vérifier la vitesse)
 * spec for "size" on hashtable
 * Dans penalties_service, on utilise IDA et on utilise penalties_service récursivement.
   Est-ce que l'un des deux ne serait pas suffisant ? Ne fait-on pas deux fois le travail ?
 * Faut-il vraiment garder box_zones_minus_1_box tel qu'il est ? Ou peut-on se satisfaire
   des sous-zones impliquant la dernière caisse poussée ?
 * Changer code de munkres pour un n2 plutôt qu'un n3?
 * Mieux calculer les zones dans penalties service
 * specs for treenode
 * Try to optimize zone with zone_pos_to_level_pos and level_pos_to_zone_pos
 * Si sous-ensemble de caisse provoque pénalité (infinie ou pas) pour toutes les
   sous-combinaisons possibles de goals, alors l'ajouter systématiquement à l'estimation de la
   méthode hongroise (c'est juste dans le cas où la pénalité n'est valable que
   pour certains goals que c'est plus difficile à mettre en place)
 * intégrer la détection de deadlocks dans l'algorithme général (pénalités à 1 caisses et plus
   à partir de 2 caisses)
 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   poussée ?
