# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * réparer les appels cassés à parent_solver partout
 * spec for "size" on hashtable
 * Réduire la taille des hashtables des sous-solveurs
 * specs pour subnodes
 * specs pour penalties
 * specs for treenode
 * Faire passer tous les specs sauf les solver trop longs à mettre en pending
 * Eviter la boucle supplémentaire pour faire << en utilisant un concat (vérifier la vitesse)
 * plutôt que de lancer un IDA* dans les pénalités, lancer un star avec un bound ?
 * Faut-il activer la recherche de pénalité dans tous les cas au niveau des sous-nodes?

 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   poussée ?
 * Vérifier que notre A* est bien optimal (avec des tests !). Doit-il vraiment l'être ?
 * Changer code de munkres pour un n2 plutôt qu'un n3?
 * Try to optimize zone with zone_pos_to_level_pos and level_pos_to_zone_pos
