import pickle

# Open the file
with open('saved_episode_2.pkl', 'rb') as f:
    data = pickle.load(f)

# See what's inside
print(type(data))
print(data.keys())

for key in data:
    print(f"{key}: {type(data[key])}")


for x in data['grid']:
    print(x)

for x in data['agents']:
    print(x)