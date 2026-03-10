# basic parameters
width=50
height=50
number_of_agents=26
max_num_cities=13
seed=43
grid_mode=False
max_rails_between_cities=2
max_rail_pairs_in_city=2
remove_agents_at_target=True

# speed
# speed_ratio_map={1 : 0.4,
#                 1/2 : 0.4,
#                 1/3 : 0.2
#                 }
speed_ratio_map= {
        1:   1,
        1/2: 0.00,
        1/3: 0.00,
        1/4: 0.00
    }
# malfunctions
malfunction_rate=0/30
min_duration=2
max_duration=6


# project related
rolling_stock = False

if rolling_stock:

    # train capacities to randomly choose from (max total car weight per train)
    train_types = [20, 10, 5]

    # cars per station
    max_cars_at_stations = 2

    # car attributes
    car_weight_range = (1, 5)
    car_value_range = (1, 10)