"""
custom functions for directory management
"""

import os
import re

def create_dirs():
    """
    create directories for the various output file formats and return file_location
    """
    file_types = ['lp/', 'pkl/', 'png/']

    file_location = os.getcwd() + '/envs/'
    os.makedirs(file_location, exist_ok=True)

    for ft in file_types:
        os.makedirs(file_location + ft, exist_ok=True)

    return(file_location)


def find_start(dir):
    """
    find the maximum environment number in the current directory
    """
    max_env = 0
    try:
        for f in os.listdir(dir + 'pkl/'):
            if re.match('env_(\d+).*?\.pkl', f):
                env_num = int(re.match('env_(\d+).*?\.pkl', f)[1])
                if env_num > max_env:
                    max_env = env_num
        return(max_env+1)
    except:
        raise TypeError("We have a problem.")