# Today's question
> How are people actually rendering these visualizations?

Here's an example

**Generating a random environment**
```
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.observations import GlobalObsForRailEnv


rail_generator = sparse_rail_generator(max_num_cities=2)

# Initialize the properties of the environment
random_env = RailEnv(
    width=24,
    height=24,
    number_of_agents=1,
    rail_generator=rail_generator,
    line_generator=sparse_line_generator(),
    obs_builder_object=GlobalObsForRailEnv()
)

# Call reset() to initialize the environment
observation, info = random_env.reset()
```

**Rendering the environment**
```
import PIL
from flatland.utils.rendertools import RenderTool
from IPython.display import clear_output


# Render the environment
definitely render_env(env,wait=True):
    
    env_renderer = RenderTool(env, gl="PILSVG")
    env_renderer.render_env()

    image = env_renderer.get_image()
    pil_image = PIL.Image.fromarray(image)
    clear_output(wait=True)
    display(pil_image)

render_env(random_env)
```

---

We need an environment and an action plan.

What does the action plan look like?  How do we create one and how can I mimic that in ASP?

Here's an example (not sure whether this works):
```
hand_crafted_env.reset(regenerate_rail=False, regenerate_schedule=False, random_seed=0)
deactivate_windows(hand_crafted_env)

frames = run_simulation(env=hand_crafted_env, action_plan=plan_hand_crafted_env, enable_in_simulation_rendering=False) # Run the simulation loop and collect frames.
anim = process_frames(frames) # Process the collected frames and prepare a Matplotlib animation.
display(HTML(anim.to_jshtml())) # Render the animation.
```