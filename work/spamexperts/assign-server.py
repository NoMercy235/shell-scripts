"""
You must have a config file with your trac credentials

Example "$HOME/.testservers.conf":

[Login]
username = <trac username>
password = <trac password>


Example usage:
    --mine [--user <username>]
    --assign <server> [--user <username>]
    --unassign <server> [--user <username>]
    --byebye [--user <username>]
    --save [--user <username>]

"""

from __future__ import print_function

import os
import re
import sys
import json
import random
import smtplib
import argparse
import requests
import ConfigParser

requests.packages.urllib3.disable_warnings()

FORM_TOKEN_RE = re.compile(r"""name="__FORM_TOKEN" value="(?P<value>\w*)""")


def trac_login(session, user, password):
    """GIVE ME COOKIES."""
    result = session.get("https://trac.spamexperts.com/login")
    value = FORM_TOKEN_RE.search(result.text).group("value")
    data = {
        "__FORM_TOKEN": value,
        "referer": "https://trac.spamexperts.com",
        "user": user,
        "password": password
        }
    session.post("https://trac.spamexperts.com/login", data=data)


def get_servers(session, showResults=False):
    """Get all the servers."""
    result = session.get("https://testservers.seinternal.com")
    result = session.get("https://testservers.seinternal.com/list")
    if showResults:
        print(result.json())
    return result.json()


def show_your_servers(session, user):
    """All your base are belong to us"""
    myservers = get_servers(session)
    myservers = list(filter_servers(myservers, {"owner": user}))
    if len(myservers):
        print("\nThese are my jelly beans:")
        print("------------------------------------------")
    for server in myservers:
        print(server['name'])
    print("\n")


def filter_servers(servers, include=None, reverse=False):
    """I like the yellow m&ms I don't like the blue m&ms"""
    include = include or {}
    for server in servers:
        for key, value in include.items():
            if reverse:
                if server[key] == value:
                    break
            else:
                if server[key] != value:
                    break
        else:
            yield server


def assign_server(session, server_name, user):
    """My precious."""
    servers = get_servers(session)
    group = "Available regular servers"
    servers = filter_servers(servers, {"name": server_name, "group": group})
    servers = filter_servers(servers, {"owner": user}, reverse=True)
    for server in servers:
        data = {
            "id": server['id'],
            "name": server['name'],
            "origOwner": None,
            "owner": "kostas",
            "sp_branch": "trunk",
            "sw_branch": "trunk",
            "sw_rev": None,
            }
        request_modification(session, data)
    print("Server %s is yours for %s" % (server_name,
                                        random.choice(["wrecking",
                                                        "breaking",
                                                        "shaking",
                                                        "@#$@%^$%@@#$"])))

def assign_random_server(session, user):
    """My precious."""
    servers = get_servers(session)
    group = "Available regular servers"
    servers = filter_servers(servers, {"group": group})
    servers = filter_servers(servers, {"owner": user}, reverse=True)
    server = random.choice(list(servers))
    data = {
        "id": server['id'],
        "name": server['name'],
        "origOwner": None,
        "owner": user,
        "sp_branch": "trunk",
        "sw_branch": "trunk",
        "sw_rev": None,
    }
    request_modification(session, data)
    print("Server %s is yours for %s" % (server['name'],
                                         random.choice(["wrecking",
                                                        "breaking",
                                                        "shaking",
                                                        "@#$@%^$%@@#$"])))

def assign_highest_server(session, user):
    """
      Similar to 'assign_random_server', except that this one assigns the highest available server.
    """
    servers = get_servers(session)
    group = "Available regular servers"
    servers = filter_servers(servers, { "group": group })
    servers = filter_servers(servers, { "owner": user }, reverse=True)
    servers = filter_servers(servers, { "isFree": True })

    bad_status_list = ( "resetting", "setup_failed" )
    for status in bad_status_list:
        servers = filter_servers(servers, { "status": status }, reverse=True)

    serversList = list(servers)
    server = serversList[len(serversList) - 1]
    data = {
        "id": server['id'],
        "name": server['name'],
        "origOwner": None,
        "owner": user,
        "sp_branch": "trunk",
        "sw_branch": "trunk",
        "sw_rev": None,
    }
    request_modification(session, data)
    print("%s" % server['name'])


def request_modification(session, data):
    """Ask Nicely."""
    server = data['id']
    url = "https://testservers.seinternal.com/task/{}".format(server)
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
    return session.post(url, data=json.dumps(data), headers=headers)


def unassign_server(session, server_name, user, cnf):
    """Share your toys."""
    servers = get_servers(session)
    servers = filter_servers(servers, {"name": server_name, "owner": user})
    for server in servers:
        data = {
            "id": server['id'],
            "name": server['name'],
            "origOwner": user,
            "owner": "",
            "sp_branch": "trunk",
            "sw_branch": "trunk",
            "sw_rev": None,
            }
        request_modification(session, data)


def unassign_all(session, user, cnf):
    """Time for beer(s)."""
    servers = get_servers(session)
    servers = filter_servers(servers, {"owner": user})
    for server in servers:
        data = {
            "id": server['id'],
            "name": server['name'],
            "origOwner": user,
            "owner": "",
            "sp_branch": "trunk",
            "sw_branch": "trunk",
            "sw_rev": None,
            }
        request_modification(session, data)


def save_servers(session, user, cnf, path):
    """Never gonna give you up."""
    servers = get_servers(session)
    servers = filter_servers(servers, {"owner": user})
    if "Servers" not in cnf.sections():
        cnf.add_section("Servers")
    cnf.set("Servers", "saved", ",".join([server['name']
                                        for server in servers]))
    with open(path, "w") as cnf_file:
        cnf.write(cnf_file)


if __name__ == "__main__":
    home_path = os.environ['HOME']
    # print(os.path.join(home_path, ".testservers.conf"))
    default_config = os.path.join(home_path, ".testservers.conf")

    opt = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawTextHelpFormatter)
    opt.add_argument("-a", "--assign", action="store_true", default=False,
                    dest="assign", help=assign_server.__doc__)

    opt.add_argument("-ah", "--assign-highest", action="store_true", default=False,
                    dest="assign_highest", help=assign_highest_server.__doc__)


    opt.add_argument("-u", "--unassign", action="store", default="",
                    dest="unassign", help=unassign_server.__doc__)

    opt.add_argument("-un", "--user", action="store", default=None, dest="user",
                    help="Time for the old switcharoo")

    opt.add_argument("-c", "--config", action="store",
                    default=default_config, dest="config",
                    help="Dear diary")

    opt.add_argument("-bb", "--byebye", action="store_true", default=False,
                    dest="byebye", help=unassign_all.__doc__)

    opt.add_argument("-m", "--mine", action="store_true", default=False,
                    dest="mine", help=show_your_servers.__doc__)

    opt.add_argument("-l", "--list", action="store_true", default=False,
                    dest="list", help=get_servers.__doc__)


    args = opt.parse_args()
    config = ConfigParser.ConfigParser()
    config.read(args.config)
    s = requests.Session()
    trac_login(s, config.get("Login", "username"),
            config.get("Login", "password"))

    username = config.get("Login", "username")
    if args.user:
        username = args.user

    if args.unassign:
        unassign_server(s, args.unassign, username, config)

    if args.assign:
        # assign_server(s, args.assign, username)
        assign_random_server(s, username)

    if args.assign_highest:
        assign_highest_server(s, username)

    # if args.save:
    #     save_servers(s, username, config, args.config)

    if args.mine:
        show_your_servers(s, username)

    if args.list:
        get_servers(s, True)

    if args.byebye:

        print("so long and thanks for all the fails")
        unassign_all(s, username, config)
        save_servers(s, username, config, args.config)
