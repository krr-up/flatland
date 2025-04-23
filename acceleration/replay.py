import imageio.v2 as imageio
import os

# Make sure your images are sorted correctly
file_names = sorted([fn for fn in os.listdir('Images/Avoiding/') if fn.endswith('.bmp')])

# Read images and write video
with imageio.get_writer('output.mp4', fps=10) as writer:
    for filename in file_names:
        image = imageio.imread(os.path.join('Images/Avoiding', filename))
        writer.append_data(image)
        os.remove(os.path.join('Images/Avoiding', filename))