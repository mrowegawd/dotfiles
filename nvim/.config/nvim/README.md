# How to install [Neovim](https://github.com/neovim/neovim/releases)

```bash
git clone https://github.com/neovim/neovim neovim
cd neovim
git checkout nightly
sudo make distclean CMAKE_BUILD_TYPE=Release install
```
