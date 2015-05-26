# sokoban-ruby-solver

Master Thesis implementation of Sokoban solver in Ruby

## Todo

 * Ajouter lien ![Build Status](https://www.codeship.io/projects/6e6488b0-b2b1-0132-f32a-2e477b22f50d/status)
 * Créer fichier log par solver.
 * Téléporter une caisse vers chaque goal possible accélérerait fortement l'algo !
   (optimisation: si toutes les caisses d'un état peuvent être téléportées vers tous les goals, on peut
    supprimer les déplacements de 1 poussées car ça ne mènera à rien de plus)
 * Il faudrait éviter de prendre en compte un noeud enfant qui a déjà été ouvert dans une autre itération
   de A (par contre la solution ne sera plus bonne, que faire ?)
 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   (et pour éliminer directement tous les sous-noeuds qui ont déjà été analysés ?)
 * Paramétriser sub_nodes et pénalités pour définir le nombre de caisses qu’on veut.
 * should we search for penalties in every sub_node?
 * Should we update munkres for this one? https://github.com/maandree/hungarian-algorithm-n3
 * Tester une vraie situation en JRuby pour comparer les perfs

Pas logique de trouver ça :

################
#@             #
# # ######     #
# #  $$     #  #
# #         ## ##
# #       ###...#
# #        ##...#
# ###      ##...#
#     # ## ##...#
#####   ## ##...#
    #####   $ ###
        #     #
        #######
INFINITY

Avant ça

################
#@             #
# # ######     #
# #  $$     #  #
# #         ## ##
# #       ###...#
# #        ##...#
# ###      ##...#
#     # ## ##...#
#####   ## ##...#
    #####     ###
        #     #
        #######
INFINITY
