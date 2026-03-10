import pickle
from argparse import ArgumentParser
from pathlib import Path

from modules.utils import (
    parse_lp_file,
    normalize_parsed_lp,
    build_env_from_parsed_lp,
)


def asp2railenv(lp_path: str):
    parsed = parse_lp_file(lp_path)
    normalized = normalize_parsed_lp(parsed)
    return build_env_from_parsed_lp(normalized)


def lp_to_pkl_path(lp_path: str) -> Path:
    lp_path = Path(lp_path).resolve()

    if lp_path.suffix != ".lp":
        raise ValueError("Input file must have .lp suffix")

    lp_dir = lp_path.parent
    if lp_dir.name != "lp":
        raise ValueError("LP file must live in a directory named 'lp'")

    pkl_dir = lp_dir.with_name("pkl")
    pkl_dir.mkdir(parents=True, exist_ok=True)

    return pkl_dir / lp_path.with_suffix(".pkl").name


# for manual call on lp file 
def main():
    parser = ArgumentParser()
    parser.add_argument("lp", type=str, help="Path to LP file")
    args = parser.parse_args()

    env = asp2railenv(args.lp)

    # generators are no longer needed and are NOT picklable
    env.rail_generator = None
    env.line_generator = None

    pkl_path = lp_to_pkl_path(args.lp)
    with open(pkl_path, "wb") as f:
        pickle.dump(env, f)

    print(f"[OK] Saved RailEnv → {pkl_path}")
    print(f"[OK] Saved RailEnv → {pkl_path}")


if __name__ == "__main__":
    main()