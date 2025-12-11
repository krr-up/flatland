import os
import tempfile
import zipfile
from pathlib import Path
from typing import Callable

import pandas as pd
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.malfunction_generators import ParamMalfunctionGen, MalfunctionParameters
from flatland.envs.observations import TreeObsForRailEnv
from flatland.envs.persistence import RailEnvPersister
from flatland.envs.predictions import ShortestPathPredictorForRailEnv
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_generators import sparse_rail_generator
from yaml import safe_load

# added
from flatland.utils.rendertools import RenderTool


# defaults from Flatland 3 Round 2 Test_0, see https://flatland.aicrowd.com/challenges/flatland3/envconfig.html
def env_creator(n_agents=7,
                x_dim=30,
                y_dim=30,
                n_cities=2,
                max_rail_pairs_in_city=4,
                grid_mode=False,
                max_rails_between_cities=2,
                malfunction_duration_min=20,
                malfunction_duration_max=50,
                malfunction_interval=540,
                speed_ratios=None,
                seed=42,
                obs_builder_object=None) -> RailEnv:
    if speed_ratios is None:
        speed_ratios = {1.0: 0.25, 0.5: 0.25, 0.33: 0.25, 0.25: 0.25}
    if obs_builder_object is None:
        obs_builder_object = TreeObsForRailEnv(max_depth=3, predictor=ShortestPathPredictorForRailEnv(max_depth=50))

    env = RailEnv(
        width=x_dim,
        height=y_dim,
        rail_generator=sparse_rail_generator(
            max_num_cities=n_cities,
            seed=seed,
            grid_mode=grid_mode,
            max_rails_between_cities=max_rails_between_cities,
            max_rail_pairs_in_city=max_rail_pairs_in_city
        ),
        malfunction_generator=ParamMalfunctionGen(MalfunctionParameters(
            min_duration=malfunction_duration_min, max_duration=malfunction_duration_max, malfunction_rate=1.0 / malfunction_interval)),
        line_generator=sparse_line_generator(speed_ratio_map=speed_ratios, seed=seed),
        number_of_agents=n_agents,
        obs_builder_object=obs_builder_object,
        record_steps=True
    )
    env.reset(random_seed=seed)
    return env


def create_envs_from_metadata(metadata_template_file: Path, outdir: Path = None, initial_seed: int = 42):
    metadata = pd.read_csv(metadata_template_file)
    print(metadata.to_markdown())
    if outdir is None:
        outdir = Path.cwd()

    metadata["seed"] = initial_seed + metadata.index

    assert os.path.exists(outdir)

    with tempfile.TemporaryDirectory() as tmpdirname:
        print('Using temporary directory', tmpdirname)

        for k, v in metadata.iterrows():
            test_id = v["test_id"]
            env_id = v["env_id"]
            seed = v["seed"]
            print(f"Generating env for {test_id}/{env_id}")
            print(f"   seed: {seed}")
            print(f"   data: {v}")

            os.makedirs(f"{tmpdirname}/{test_id}", exist_ok=True)

            env = env_creator(
                n_agents=v["n_agents"],
                x_dim=v["x_dim"],
                y_dim=v["y_dim"],
                n_cities=v["n_cities"],
                max_rail_pairs_in_city=v["max_rail_pairs_in_city"],
                grid_mode=v["grid_mode"],
                max_rails_between_cities=v["max_rails_between_cities"],
                malfunction_duration_min=v["malfunction_duration_min"],
                malfunction_duration_max=v["malfunction_duration_max"],
                malfunction_interval=v["malfunction_interval"],
                speed_ratios=safe_load(v["speed_ratios"]),
                seed=seed)
            RailEnvPersister.save(env, f"{tmpdirname}/{test_id}/{env_id}.pkl")

            """
            visually render a given environment and save image to file
            """
            DO_RENDERING = True    
            env_renderer = RenderTool(env, gl="PILSVG")
            env_renderer.reset()

            if env_renderer is not None:
                env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
                env_renderer.gl.save_image(f"{tmpdirname}/{test_id}/{env_id}.png")
                env_renderer.reset()

        metadata.to_csv(f"{tmpdirname}/metadata.csv")

        zip_directory(tmpdirname, outdir / "environments.zip")


def zip_directory(directory_path, zip_path, filter: Callable[[Path], bool] = None):
    with zipfile.ZipFile(zip_path, 'w') as zipf:
        for root, dirs, files in os.walk(directory_path):
            for file in files:
                if filter is None or filter(file):
                    arcname = os.path.relpath(os.path.join(root, file), directory_path)
                    zipf.write(os.path.join(root, file), arcname)



if __name__ == '__main__':
    create_envs_from_metadata(Path("metadata.csv.template"))
