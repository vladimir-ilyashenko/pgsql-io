
import paramiko

client = paramiko.SSHClient()
client.load_system_host_keys()
client.connect('bld-amd8')

stdin, stdout, stderr = client.exec_command('ls -l')
client.close()

