#/bin/sh

export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ] || [ ! -f $SSH_AUTH_SOCK ]; then
   rm -f $SSH_AUTH_SOCK
   (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:$HOME/.ssh/wsl2-ssh-pageant.exe >/dev/null 2>&1 &)
fi
