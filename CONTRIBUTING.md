# Contributing to Mint Arch Linux

Thank you for your interest in contributing!

## Ways to Contribute

- **Report bugs** — Open an issue with the `bug` label
- **Suggest features** — Open an issue with the `enhancement` label
- **Add packages** — Edit the appropriate file in `mint-arch-linux/packages.x86_64/`
- **Improve tools** — Edit scripts in `mint-arch-linux/airootfs/usr/local/bin/`
- **Fix docs** — Edit any `.md` file and open a PR

## Package Guidelines

All packages must come from official Arch Linux repositories or AUR only:
- `[core]`, `[extra]`, `[community]` — preferred
- AUR — allowed, but mark clearly in comments
- No third-party repositories (no BlackArch repo, no custom mirrors)

When adding a package to a `.txt` file:
```
# Category name
package-name          # short description of why it's included
```

## Script Guidelines

- All `mint-*` scripts must work without external dependencies
- Use `set -euo pipefail` at the top
- Use the standard color variables (`MINT`, `GREEN`, `RED`, etc.)
- Test on a clean Arch Linux install before submitting

## Building Locally

```bash
# Requires Arch Linux host
sudo pacman -S archiso
cd mint-arch-linux
sudo ./build.sh --clean
```

Or use Docker (any OS):
```bash
cd mint-arch-linux/docker-build
bash build.sh
```

## Submitting a PR

1. Fork the repo
2. Create a branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test the build if possible
5. Open a pull request with a clear description
