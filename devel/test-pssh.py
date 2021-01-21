import sys

from pssh.clients import ParallelSSHClient

hosts = ['66.246.107.24', '66.246.107.15']

client = ParallelSSHClient(hosts, user="centos", pkey="~/keys/denisl-pubkey.pem")

cmd='python3 -c "$(curl -fsSL https://pgsql-io-download.s3.amazonaws.com/REPO/install.py)"'
#cmd='/usr/bin/python3 --version'
#cmd='uname'
#cmd='yum install -y python3 python3-devel wget curl'

output = client.run_command(cmd, sudo=True)
client.join(output)
for host_out in output:
    for line in host_out.stdout:
        print(line)

sys.exit(1)

shells = client.open_shell(read_timeout=10)
client.run_shell_commands(shells, [cmd])
client.join_shells(shells)

for shell in shells:
  stdout = list(shell.stdout)
  for s in stdout:
    print(s)
