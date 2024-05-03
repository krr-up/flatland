import pickle
env = pickle.load(open("env_17.pkl", "rb"))

print(env.rail.grid[26][7])
print(env.rail.grid[27][7])
print(env.rail.grid[27][6])
print(env.rail.grid[28][6])