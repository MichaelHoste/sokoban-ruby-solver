# Sokoban IDA* Solver (Ruby) [![Build Status](https://app.codeship.com/projects/6e6488b0-b2b1-0132-f32a-2e477b22f50d/status?branch=master)](https://app.codeship.com/projects/70056) [![Test Coverage](https://codeclimate.com/github/MichaelHoste/sokoban-ruby-solver/badges/coverage.svg)](https://codeclimate.com/github/MichaelHoste/sokoban-ruby-solver/coverage) [![Code Climate](https://codeclimate.com/github/MichaelHoste/sokoban-ruby-solver/badges/gpa.svg)](https://codeclimate.com/github/MichaelHoste/sokoban-ruby-solver)

Clean and fully tested implementation of [Sokoban](https://en.wikipedia.org/wiki/Sokoban) game logic and IDA* solver in Ruby.

## Installation

 * `brew install sdl2 libogg libvorbis rust` (on MacOS) -> rust for munkres_ru
 * **Ruby**. See `.ruby-version` for current version.
   [rbenv](https://github.com/rbenv/rbenv) is recommended to install it.
 * **SDL2**. `brew install sdl2` on MacOS (for gosu: https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X)
 * **imagemagick**. `brew install imagemagick` on MacOS (for Sokoban image generator)

## How It Works

### Level internal representation

Standard representation of Sokoban levels is:

         #####                 # -> wall
         #   #                 $ -> box
         #$  #                 . -> goal
       ###  $##                * -> box on a goal
       #  $ $ #                @ -> pusher
     ### # ## #   ######       + -> pusher on a goal
     #   # ## #####  ..#         -> floor
     #    $          .*#
     ##### ### #@##  ..#
         #     #########
         #######

Positions in level start in the upper-left corner with (m=0, n=0).
Example: (2, 4) means third rows and fifth cols starting in the upper-left
corner ('#' in this level).

Once the files are loaded in our application, the actual representation is
extended to dissociate "internal floor" and "external floor":

        #####                 # -> wall
        #sss#                 $ -> box
        #$ss#                 . -> goal
      ###ss$##                * -> box on a goal
      #ss$s$s#                @ -> pusher
    ###s#s##s#   ######       + -> pusher on a goal
    #sss#s##s#####ss..#         -> external floor
    #ssss$ssssssssss.*#       s -> internal floor
    #####s###s#@##ss..#
        #sssss#########
        #######

But since it's more difficult to read, it's never printed like this in the
console.

### Play

When reflecting on a Sokoban solver, it's sometimes useful to manually try
and solve specific situations. 2 helper methods exist for this purpose.

In both mode, use:

 * Arrow keys to move.
 * 'd' or 'backspace' to cancel the last move.
 * 'esc' to quit.

#### Visual Game

    level = Level.new("    #####          \n"\
                      "    #   #          \n"\
                      "    #$  #          \n"\
                      "  ###  $##         \n"\
                      "  #  $ $ #         \n"\
                      "### # ## #   ######\n"\
                      "#   # ## #####  ..#\n"\
                      "# $  $     @    ..#\n"\
                      "##### ### # ##  ..#\n"\
                      "    #     #########\n"\
                      "    #######        ")

    level.play

It will launch a window for you to play the game.

#### Console Game









Also, see https://sokoban-game.com

<!--

## Todo
 * Penalties > améliorer SubNodesService pour se concentrer sur les pénalités de situations problématiques
   et ignorer les autres
 * Précalculer tous les sous-niveaux avec 1..4 caisses pour avoir un set de pénalités et de deadlocks
   qui sera utilisé dans le solver du niveau réel. > si ça fait une différence, quelque chose ne va pas
   dans l'algo actuel !
 * Quand une pénalité est trouvée, ajouter automatiquement toutes les pénalités de type "tunnel" liées
   (difficile vu que le fait de bouger une caisse implique d'autres pénalités sous-jacentes).
 * Ajouter plus de tests pour NodeChildrenToGoalsService + refactorer
 * Remonter les pénalités dans les nodes originels des solveurs parents
 * Si une pénalité est trouvée, parcourir les "waiting nodes" et les retrier en fonction de
   cette nouvelle pénalité (ou bien carrément recommencer l'analyse de l'arbre pour ainsi
   purger aussi les branches invalides !?)
 * Faut il recouper les arbres entiers parents à chaque nouvelle pénalité trouvée pour gagner du temps ?
   (lors de l'analyse du premier noeud parent, on a très vite une pénalité qui permettrait de l'invalider)
 * PISTE : Il y a des états inutiles qu'on veut supprimer. Souvent ce sont les états qui ont les
   mêmes pusher_zones (et nombre de caisses) et qui représentent au final la même situation.
   Une fois que la téléportation des caisses vers les goals sera faite, modifier la table de hashage
   (fonction de hashage et include?) pour éliminer les états redondants.
 * Améliorer la sortie standard (total_tries, nombre d'itérations pour chaque niveau de caisses, etc.)
 * améliorer SubNodesService et PenaltiesService pour ne prendre en compte que la dernière caisse
   (et pour éliminer directement tous les sous-noeuds qui ont déjà été analysés ?)
 * Paramétriser sub_nodes et pénalités pour définir le nombre de caisses qu’on veut.
 * Définir variables globales pour activer/désactiver certains services
 * should we search for penalties in every sub_node?
 * Should we update munkres for this one? https://github.com/maandree/hungarian-algorithm-n3
 * Tester une vraie situation en JRuby pour comparer les perfs
 * Adopt some services to multi-threads computing (GPU?) or C++, or both

 -->
