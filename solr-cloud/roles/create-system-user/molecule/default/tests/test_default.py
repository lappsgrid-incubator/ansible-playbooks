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


def test_user_exists(host):
    u = host.user("foobar")
    assert u.name == 'foobar'
    assert u.home == '/home/foobar'


def test_home_directory(host):
    h = host.file('/home/foobar')
    assert h.exists
    assert h.user == 'foobar'
    assert h.group == 'foobar'
