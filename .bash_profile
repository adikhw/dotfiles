# ~/.bash_profile -- bash login shells (TTY logins, `bash -l`).
# .bashrc loads the shared PATH, so just pull it in.
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
