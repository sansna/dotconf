# /etc/profile: execute while logging in.
# The following starts ssh-agent at specified path.
# All the other sessions can connect to this by:
#SSH_AUTH_SOCK=/path/to/agent;export SSH_AUTH_SOCK;
#SSH_AGENT_PID=`ps aux|grep ssh-agent|grep -v grep|gawk '{print $2}'`;export SSH_AGENT_PID;
eval `sudo -u user bash -c "ssh-agent -a /path/to/agent"` 1>/dev/null
