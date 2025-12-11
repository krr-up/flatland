from modules.save import save_png
import os
import sys

env = sys.argv[2]
print(os.path.basename(env))
print("dir")
print(os.path.dirname(env))

#save_png(env, file_name, path)