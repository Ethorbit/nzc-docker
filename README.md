# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles Garry's Mod servers. 

## Creating
Instead of using `docker-compose`, execute compose.sh with the usual arguments. 
compose.sh is a script that will automatically create several gmod servers (it was designed to avoid repetitive yaml properties)

To start:
`./compose.sh up -d`

To remove:
`./compose.sh down`

