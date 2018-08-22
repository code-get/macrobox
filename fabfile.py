
from fabric.api import *

env.hosts = [
    'vagrant@127.0.0.1:2222'
]

env.password = "vagrant"

@parallel
def cmd(command):
    run(command)