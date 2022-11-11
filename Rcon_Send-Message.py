from rcon.battleye import Client

with Client('127.0.0.1', 2307, passwd='YOUR_RCON_PASS') as client:
    response = client.run('Say -1 DETECTED MODS UPDATE! SERVER RESTART IN 10 MINUTES!')

print(response)