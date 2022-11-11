from rcon.battleye import Client

with Client('127.0.0.1', 2307, passwd='YOUR_RCON_PASS') as client:
    response = client.run('players')

print(response)