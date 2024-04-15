import streamlit as st
import os
import pandas as pd
import subprocess as subp
import re
from gen_functions import *

def create_env():
    pass

st.markdown("# Rail Environment Generator")

tab1, tab2 = st.tabs(["Create", "Generate"])

with tab1:
    st.markdown("## Create environments")
    num_envs = st.number_input("Number of environments", min_value=1, max_value=3, value="min", step=1)
    st.markdown("")
    st.markdown("Establish the parameters of the environments to be created.")

    # Height and width of environment
    colHeight, colWidth = st.columns(2)
    with colHeight:
        height = st.number_input("Environment height", min_value=30, max_value=60, value="min", step=1)
    with colWidth:
        width = st.number_input("Environment width", min_value=30, max_value=60, value="min", step=1)

    # Number of trains and cities
    colTrains, colCities = st.columns(2)
    with colTrains:
        num_trains = st.number_input("Number of trains", min_value=1, max_value=5, value="min", step=1)
    with colCities:
        num_cities = st.number_input("Number of cities", min_value=2, max_value=5, value="min", step=1)

    # Advanced options
    with st.expander("Advanced options", expanded=False):
        # find file names
        files = os.listdir()
        default_envs = [file for file in files if file[:3] == "env"]
        env_nums = [int(re.search('env_(\d+)', env, re.IGNORECASE).group(1)) for env in default_envs]
        #file_name = st.text_input('File name', value='env_{}'.format(max(env_nums)+1))
        #st.markdown('---')

        grid_mode = st.checkbox("Grid mode", value=True)
        max_rails_between = st.number_input("Rails between cities", min_value=2, max_value=6, value="min", step=1)
        max_rails_within = st.number_input("Parallel rails within a city", min_value=2, max_value=6, value="min", step=1)

    # Generate
    create = st.button("Create environments", key=None, help=None, on_click=None, use_container_width=True, type="primary")
    if create:

        # functions
        new_file_idx = max(env_nums) + 1
        for idx in range(new_file_idx, num_envs+new_file_idx):
            env = generate(width=width, height=height, nr_trains=num_trains, cities_in_map=num_cities, seed=idx, grid_distribution_of_cities=grid_mode, max_rails_between_cities=max_rails_between, max_rail_in_cities=max_rails_within)
            clingo_env = convert_rail_to_clingo(env, height)
            current_wd = os.getcwd()+"/"
            os.makedirs(current_wd + "env_{:01d}/".format(idx), exist_ok=True)
            save_render(env, idx, current_wd)
            save_env(env, idx, current_wd)
            save_clingo(clingo_env, idx, current_wd)
            with open(current_wd + "env_{:01d}/env_{:01d}.txt".format(idx, idx), "w") as output:
                output.write("env_{:01d}".format(idx) + "\n" +
                             "height/width:\t{},{}".format(height, width) + "\n" +
                             "trains/cities:\t{},{}".format(num_trains, num_cities) + "\n" +
                             "rails between/within:\t{},{}".format(max_rails_between, max_rails_within))

        # verification
        success = min([os.path.exists(os.getcwd()+"/env_{:01d}/".format(idx)) for idx in range(num_envs)])
        if success:
            plurality = {True : "environment has", False : "environments have"}
            st.markdown(f'{num_envs} {plurality[num_envs == 1]} been created!')



with tab2:
    st.markdown("## Generate paths")

    colFiles, colEnv = st.columns(2)
    with colFiles:
        # Logical files
        st.markdown("### Necessary files")
        st.markdown("Choose pathfinding files")
        files = os.listdir()
        default_files = [file for file in files if file[-3:] == ".lp"]
        st.multiselect("Files", files, default_files)

    with colEnv:
    # Environment files
        st.markdown("### Environment")
        st.markdown("Choose the environment")
        default_envs = [file for file in files if file[:3] == "env"]
        selected_env = st.selectbox("Environment", default_envs)

    generate = st.button("Generate paths", key=None, help=None, on_click=None, use_container_width=True, type="primary")

    if generate:
        test_str = str(selected_env) + '/' + str(selected_env) +'.lp'
        gen_run = subp.run(['bash', 'test.sh', f'{test_str}'], stdout=subp.PIPE)
        st.write(gen_run.stdout.decode('utf-8'))

    st.markdown("---")

    with st.expander("Results"):
        st.write("Performance results.")

        st.button("Save results")
   
    



#if generate:
    #st.write(f'{num_envs} {height} {width} {num_trains} {num_cities} {grid_mode} {max_rails_between} {max_rails_within}')
    #st.markdown(convert_rail_to_clingo(generate(width=width, height=height, nr_trains=num_trains, cities_in_map=num_cities, seed=14, grid_distribution_of_cities=grid_mode, max_rails_between_cities=max_rails_between, max_rail_in_cities=max_rails_within), height))
