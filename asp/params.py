#primary=['asp/graph_based/actions.lp','asp/graph_based/graph.lp','asp/graph_based/traverse.lp']
#primary=['asp/action_based/actions.lp','asp/action_based/pathfinding.lp','asp/action_based/transitions.lp']

# karl encoding
#primary=[]

# tim encoding
#primary=['asp/']
# primary=['asp/tk/encoding.lp', 'asp/tk/tracks.lp']
# primary=['asp/tk/speed_revamp.lp', 'asp/tk/tracks.lp']
# primary=['asp/tk/tracks_trajectories.lp', 'asp/tk/trajectory_encoding.lp']
primary=['asp/tk/encoding_incremental.lp', 'asp/tk/tracks_incremental.lp']
# primary=['asp/tk/encoding_incremental_cond_conn.lp', 'asp/tk/tracks_incremental_cond_conn.lp']
# primary=['asp/tk/encoding.lp', 'asp/tk/tracks.lp']
primary=['asp/tk/speed_revamp.lp', 'asp/tk/tracks.lp']
# primary=['asp/tk/encoding_transition.lp', 'asp/tk/tracks_transition.lp']


# -------------- moving cars --------------
# ------ batch linking encoding ------ (comment out LIFO encoding to ignore sequencing constraints)
primary=['asp/cars_choice_order/encoding_incremental_enriched.lp',
         'asp/cars_choice_order/tracks_incremental_enriched.lp',
         'asp/cars_choice_order/moving_cars.lp',
         'asp/cars_choice_order/lifo.lp'
         ]

# ------ single operation encoding ------ (comment out LIFO encoding to ignore sequencing constraints)
# primary=['asp/cars_temporal_order/encoding_incremental_enriched.lp',
#          'asp/cars_temporal_order/tracks_incremental_enriched.lp',
#          'asp/cars_temporal_order/moving_cars.lp',
#          'asp/cars_temporal_order/lifo.lp'
#          ]

secondary=[]