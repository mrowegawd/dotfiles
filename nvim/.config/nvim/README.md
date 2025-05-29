# Quick install [Neovim](https://github.com/neovim/neovim/releases) :zipper_mouth_face:

```bash
# Install neovim
git clone https://github.com/neovim/neovim neovim
cd neovim && git checkout master
git checkout nightly
make distclean && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install

# Update nvim
git pull --rebase --prune

# Update tags
git fetch --all --tags -f
```
