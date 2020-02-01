import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


# def test_user(host):
#    u = host.user('zookeeper')
#     assert u.home == '/home/zookeeper'
#
#
def test_directory(host):
    home = '/home/zookeeper'
    dirs = [home, home + '/bin', home + '/conf']
    for dir in dirs:
        f = host.file(dir)
        assert f.exists
