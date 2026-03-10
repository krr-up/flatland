import numpy as np
from typing import Tuple, List
from flatland.envs.rail_env import RailEnv
from flatland.envs.timetable_utils import Line
from flatland.envs.rail_trainrun_data_structures import Waypoint
from flatland.envs.rail_grid_transition_map import RailGridTransitionMap


DIR_MAP = {'n':0, 'e':1, 's':2, 'w':3}


def extract_stations(env: RailEnv) -> List[Tuple[int, int]]:
    """
    Extract all unique station coordinates from a RailEnv.
    Stations are defined as all agent initial positions and target positions.

    Args:
        env (RailEnv): The Flatland RailEnv environment.

    Returns:
        stations: (List[Tuple[int, int]]): A list of unique station coordinates as (row, col) tuples.
    """

    stations = set()
    for agent in env.agents:
        stations.add(agent.initial_position)
        stations.add(agent.target)
    stations = list(stations)
    return stations

# collection of helper functions used in the context of our project
def sample_station(stations: List[Tuple[int, int]],
                   rng: np.random.Generator) -> Tuple[int, int]:
    """
    given a list of stations returns a sampled station, e.g. to be used as a target

    Args:
        stations (list): a list of stations, i.e. coordinates in the environment grid which are targets or inital positions
        rng (np.random.Generator): a random number generator used for reproducibility
    Returns:
        stations (Tuple[int, int]): a station, i.e. tuple referencing coordinates in an environment grid

    """
    idx = rng.randint(len(stations))
    return stations[idx]

def sample_distinct_station(stations: List[Tuple[int, int]],
                            exclude: Tuple[int, int],
                            rng: np.random.Generator) -> Tuple[int, int]:
    
    """
    Sample a station from a list of stations that is different from a given one, e.g. the intial position

    Args:
        stations (List[Tuple[int, int]]): List of station coordinates as (row, col) tuples.
        exclude (Tuple[int, int]): Station coordinate to exclude from sampling, e.g. the initial position
        rng (np.random.Generator): Random number generator used for reproducibility.

    Returns:
        Tuple[int, int]: A sampled station coordinate different from 'exclude'.
    """
    
    candidates = [s for s in stations if s != exclude]
    if not candidates:
        raise ValueError("No distinct station available")
    
    return sample_station(candidates, rng)

def generate_cars_per_station(env: RailEnv) -> None:
    """
    Generate 0..max_cars_at_stations cars at each station.
    Cars are stored in env.cars.
    """

    rng = env.np_random
    stations = env.stations

    if len(stations) < 2:
        raise ValueError("Need at least two stations to generate cars")

    env.cars = {}
    car_id = 0

    for station in stations:
        # number of cars at this station
        num_cars = rng.randint(0, env.max_cars_at_stations + 1) # have to use this because of 'legacy version' of np in flatland

        for _ in range(num_cars):
            target = sample_distinct_station(stations, station, rng)

            env.cars[car_id] = {
                "start": station,
                "target": target,
                "weight": int(rng.randint(*env.car_weight_range)),
                "value": int(rng.randint(*env.car_value_range)),
                "on_train": None
            }
            car_id += 1


def assign_train_capacities(env: RailEnv) -> None:
    rng = env.np_random
    env.train_capacity = {}

    for train_id in range(len(env.agents)):
        capacity = rng.choice(env.train_types)
        env.train_capacity[train_id] = int(capacity)


def parse_lp_file(file_path: str):
    with open(file_path) as f:
        lines = f.readlines()

    # remove full-line and inline comments
    code_lines = []
    for line in lines:
        line = line.split('%', 1)[0].strip()
        if line:
            code_lines.append(line)

    # join and split into facts
    clingo_code = ' '.join(code_lines)
    facts = [fact.strip() for fact in clingo_code.split('.') if fact.strip()]

    global_val = None
    stations = []
    cells = []
    trains = {}
    cars = {}

    replace_paren = lambda s: s.replace('(', '').replace(')', '')

    # ---- processors ----

    def process_cell(fact):
        content = replace_paren(fact.replace('cell', ''))
        x, y, track_type = [v.strip() for v in content.split(',')]
        cells.append((x, y, track_type))

    def process_station(fact):
        content = replace_paren(fact.replace('station', ''))
        x, y = [v.strip() for v in content.split(',')]
        stations.append((x, y))

    def process_global(fact):
        nonlocal global_val
        content = replace_paren(fact.replace('global', ''))
        global_val = int(content)

    def process_train_fact(fact):
        name, rest = fact.split('(', 1)
        args = replace_paren(rest).split(',')

        train_id = args[0].strip()
        trains.setdefault(train_id, {})

        if name == 'start':
            trains[train_id]['start'] = tuple(a.strip() for a in args[1:])
        elif name == 'end':
            trains[train_id]['end'] = tuple(a.strip() for a in args[1:])
        elif name == 'speed':
            trains[train_id]['speed'] = args[1].strip()
        elif name == 'train_capacity':
            trains[train_id]['capacity'] = args[1].strip()

    def process_car_fact(fact):
        name, rest = fact.split('(', 1)
        args = replace_paren(rest).split(',')

        car_id = args[0].strip()
        cars.setdefault(car_id, {})

        if name == 'car_start':
            cars[car_id]['start'] = tuple(a.strip() for a in args[1:])
        elif name == 'car_target':
            cars[car_id]['target'] = tuple(a.strip() for a in args[1:])
        elif name == 'car_weight':
            cars[car_id]['weight'] = args[1].strip()
        elif name == 'car_value':
            cars[car_id]['value'] = args[1].strip()

    # ---- main dispatch ----

    for fact in facts:
        if fact.startswith('cell'):
            process_cell(fact)
        elif fact.startswith('station'):
            process_station(fact)
        elif fact.startswith('global'):
            process_global(fact)
        elif fact.startswith(('train', 'start', 'end', 'speed', 'train_capacity')):
            process_train_fact(fact)
        elif fact.startswith(('car', 'car_start', 'car_target', 'car_weight', 'car_value')):
            process_car_fact(fact)

    return {
        'global': global_val,
        'stations': stations,
        'cells': cells,
        'trains': trains,
        'cars': cars,
    }

def normalize_parsed_lp(parsed):
    """
    Converts strings → ints, directions → enums,
    splits composite tuples, validates completeness.

    Input: output of parse_lp_file(...)
    Output: dict with normalized cells, trains, cars, stations, global
    """

    DIR_MAP = {'n': 0, 'e': 1, 's': 2, 'w': 3}

    # -----------------
    # Global
    # -----------------
    if parsed['global'] is None:
        raise ValueError("Missing global/1 fact")
    max_time = int(parsed['global'])

    # -----------------
    # Cells
    # -----------------
    if not parsed['cells']:
        raise ValueError("No cell/2 facts found")

    cells = {}
    for r, c, t in parsed['cells']:
        cells[(int(r), int(c))] = int(t)

    # -----------------
    # Stations
    # -----------------
    stations = [(int(r), int(c)) for r, c in parsed['stations']]

    # -----------------
    # Trains
    # -----------------
    trains = {}

    for tid, data in parsed['trains'].items():
        missing = {'start', 'end', 'speed', 'capacity'} - data.keys()
        if missing:
            raise ValueError(f"Train {tid} missing fields: {missing}")

        # start(ID,(r,c),dep,dir)
        sr, sc, dep, d = data['start']
        if d not in DIR_MAP:
            raise ValueError(f"Invalid direction '{d}' for train {tid}")

        start_pos = (int(sr), int(sc))
        start_dir = DIR_MAP[d]
        earliest_dep = int(dep)

        # end(ID,(r,c),t)
        er, ec, arr = data['end']
        target_pos = (int(er), int(ec))
        target_time = int(arr)

        trains[int(tid)] = {
            'start_pos': start_pos,
            'start_dir': start_dir,
            'earliest_dep': earliest_dep,
            'target_pos': target_pos,
            'target_time': target_time,
            'speed': int(data['speed']),
            'capacity': int(data['capacity']),
        }

    # -----------------
    # Cars
    # -----------------
    cars = {}

    for cid, data in parsed['cars'].items():
        missing = {'start', 'target', 'weight', 'value'} - data.keys()
        if missing:
            raise ValueError(f"Car {cid} missing fields: {missing}")

        sr, sc = data['start']
        tr, tc = data['target']

        cars[int(cid)] = {
            'start': (int(sr), int(sc)),
            'target': (int(tr), int(tc)),
            'weight': int(data['weight']),
            'value': int(data['value']),
        }


    return {
        'global': max_time,
        'cells': cells,               # {(r,c): track_type}
        'stations': stations,         # [(r,c)]
        'trains': trains,             # {id: {...}}
        'cars': cars,                 # {id: {...}}
    }

def infer_grid_size(cells):
    max_r = max(r for (r, c) in cells.keys())
    max_c = max(c for (r, c) in cells.keys())
    return max_r + 1, max_c + 1

def make_lp_rail_generator(cells: dict, width: int, height: int):
    def rail_generator(width_, height_, num_agents, num_resets, np_random):
        rail = RailGridTransitionMap(width=width, height=height)
        rail.grid[:] = 0
        for (r, c), track in cells.items():
            rail.grid[r, c] = track
        return rail, {}
    return rail_generator

def make_lp_line_generator(trains: dict):
    def line_generator(rail, num_agents, hints, num_resets, np_random):
        waypoints = []
        speeds = []

        for tid in sorted(trains):
            t = trains[tid]

            waypoints.append([[
                Waypoint(position=t["start_pos"], direction=t["start_dir"]),
                Waypoint(position=t["target_pos"], direction=None)
            ]])

            # ASP duration -> Flatland speed
            speeds.append(1.0 / t["speed"])

        return Line(
            agent_waypoints=waypoints,
            agent_speeds=speeds
        )

    return line_generator

def build_env_from_parsed_lp(parsed: dict) -> RailEnv:
    cells = parsed["cells"]
    trains = parsed["trains"]

    width, height = infer_grid_size(cells)

    rail_gen = make_lp_rail_generator(cells, width, height)
    line_gen = make_lp_line_generator(trains)

    env = RailEnv(
    width=width,
    height=height,
    rail_generator=rail_gen,
    line_generator=line_gen,
    number_of_agents=len(trains),
    remove_agents_at_target=True
)

    env.reset()

    # overrite max global steps information
    env._max_episode_steps = parsed["global"]

    for agent_id, agent in enumerate(env.agents):
        t = trains[agent_id]

        agent.target = t["target_pos"]
        agent.earliest_departure = t["earliest_dep"]
        agent.latest_arrival = t["target_time"]


    # ---- project-level enrichment (NOT Flatland core) ----
    env.stations = parsed["stations"]
    env.train_capacity = {
        tid: trains[tid]["capacity"] for tid in trains
    }
    env.cars = parsed["cars"]
    env.max_time = parsed["global"]

    return env

def asp2railenv(file_path) -> RailEnv:
    parsed = parse_lp_file(file_path)
    normalized = normalize_parsed_lp(parsed)
    env = build_env_from_parsed_lp(normalized)
    return env