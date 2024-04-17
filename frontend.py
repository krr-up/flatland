import streamlit as st
import os
import pandas as pd
import subprocess 
import re
import glob
from modules.create_environments import save

def create_env():
    pass

st.markdown("# Rail Environment Generator")

tab1, tab2 = st.tabs(["Create", "Generate"])

with tab1:
    st.markdown("## Create environments")
    num_envs = st.number_input("Number of environments", min_value=1, max_value=3, step=1)
    st.markdown("")
    st.markdown("Establish the parameters of the environments to be created.")

    # Height and width of environment
    colHeight, colWidth = st.columns(2)
    with colHeight:
        height = st.number_input("Environment height", min_value=30, max_value=90, step=1)
    with colWidth:
        width = st.number_input("Environment width", min_value=30, max_value=90, step=1)

    # Number of trains and cities
    colTrains, colCities = st.columns(2)
    with colTrains:
        num_trains = st.number_input("Number of trains", min_value=1, max_value=30, step=1)
    with colCities:
        num_cities = st.number_input("Number of cities", min_value=2, max_value=15, step=1)

    # Advanced options
    with st.expander("Advanced options", expanded=False):
        grid_mode = st.checkbox("Grid mode", value=True)
        max_rails_between = st.number_input("Rails between cities", min_value=2, max_value=10, step=1)
        max_rails_within = st.number_input("Parallel rails within a city", min_value=2, max_value=10, step=1)

    # Generate
    create = st.button("Create environments", key=None, help=None, on_click=None, use_container_width=True, type="primary")
    if create:
        subprocess.run(["python3", "environments.py", str(num_envs), str(width), str(height), str(num_trains), str(num_cities), str({True:1,False:0}[grid_mode]), str(max_rails_between), str(max_rails_within)], shell=False)

        # verification
        success = True # under constrution
        if success:
            plurality = {True : "environment has", False : "environments have"}
            st.markdown(f'{num_envs} {plurality[num_envs == 1]} been created!')



with tab2:
    st.markdown("## Generate paths")

    generated = False

    colFiles, colEnv = st.columns(2)
    with colFiles:
        # Logical files
        st.markdown("### Necessary files")
        st.markdown("Choose pathfinding files")
        files = os.listdir(path = 'encodings')
        default_files = [file for file in files if file[-3:] == ".lp"]
        selected_files = st.multiselect("Files", files, default_files)

    with colEnv:
    # Environment files
        st.markdown("### Environment")
        st.markdown("Choose the environment")
        default_envs = os.listdir(path = 'envs/pkl')
        selected_env = st.selectbox("Environment", default_envs)

    generate = st.button("Generate paths", key=None, help=None, on_click=None, use_container_width=True, type="primary")

    if generate:
        selected_files_str = ""
        for file in selected_files: selected_files_str += f"encodings/{str(file)}"

        with st.spinner(text="In progress..."):
            subprocess.run(["python3", "paths.py", f"envs/pkl/{selected_env}", selected_files_str], shell=False)

        st.success("Process has completed. View results below.")
        list_of_files = glob.glob('output/*') # * means all if need specific format then *.csv
        latest_file = max(list_of_files, key=os.path.getctime)
        generated = True


    st.markdown("---")

    with st.expander("Results"):
        #st.write("Performance results.")
        if generated:
            output = st.image(latest_file+"/animation.gif")

        st.button("Save results")
   
    



#if generate:
    #st.write(f'{num_envs} {height} {width} {num_trains} {num_cities} {grid_mode} {max_rails_between} {max_rails_within}')
    #st.markdown(convert_rail_to_clingo(generate(width=width, height=height, nr_trains=num_trains, cities_in_map=num_cities, seed=14, grid_distribution_of_cities=grid_mode, max_rails_between_cities=max_rails_between, max_rail_in_cities=max_rails_within), height))
