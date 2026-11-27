import json
import re
import sys
from pathlib import Path, PurePosixPath
from zipfile import ZipFile


def manifests(archive):
    modules = {}
    with ZipFile(archive) as files:
        for entry in files.namelist():
            parts = PurePosixPath(entry).parts[1:]
            if not parts or parts[-1] != "manifest.json":
                continue
            if parts[0] == "Modules" and 3 <= len(parts) <= 4:
                settings = json.loads(files.read(entry).decode("utf-8-sig"))
                if "enable" in settings:
                    modules[parts[-2]] = settings["enable"]
            elif parts in (("Online", "manifest.json"), ("SISI", "manifest.json")):
                modules[parts[0]] = json.loads(files.read(entry).decode("utf-8-sig"))["enable"]
    return modules


before, after = map(manifests, sys.argv[1:3])
addon = Path(sys.argv[3])
selectors = re.findall(r'"list\(([^)]+)\)"', (addon / "config.yaml").read_text(encoding="utf-8"))
selectable = {name for selector in selectors for name in selector.split("|")}
runner = (addon / "run.sh").read_text(encoding="utf-8")
managed = set(re.search(r"MANIFEST_MANAGED_MODULES=\((.*?)\)", runner, re.S)[1].split())

print("### Upstream Lampac modules")
for name in sorted(after.keys() - before.keys()):
    state = "listed in HA" if name in selectable else "missing from HA selectors"
    print(f"- Added `{name}` ({state}).")
for name in sorted(before.keys() - after.keys()):
    print(f"- Removed or renamed `{name}`.")
for name in sorted(before.keys() & after.keys()):
    if before[name] != after[name]:
        print(f"- `{name}` manifest enable changed to `{str(after[name]).lower()}`.")
for name in sorted((selectable & after.keys()) - managed):
    if not after[name]:
        print(f"- `{name}` is selectable but its disabled manifest is unmanaged.")
if before == after:
    print("- Module inventory and manifest defaults match the previous tag.")
