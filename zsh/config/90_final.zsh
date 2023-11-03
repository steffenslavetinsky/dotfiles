

if [[ $UNAME == "mac" ]] && [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
else
  . "$HOME/.asdf/asdf.sh"
fi