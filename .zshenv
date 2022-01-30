
export PATH="$HOME/.mydocker3/private/bin:$HOME/.mydocker3/public/bin:$PATH"

export PYENV_ROOT=/opt/mydocker3/.pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

export RBENV_ROOT=/opt/mydocker3/.rbenv
export PATH=$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH

if [ -e $HOME/.mydocker3/public/.zshenv-local ]; then
  . $HOME/.mydocker3/public/.zshenv-local
fi
