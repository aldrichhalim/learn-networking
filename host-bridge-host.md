# Notes

Run the ip show command to list the newly created namespaces.

```sh
sudo ip netns show

```

Make sure host can talk to each other.

```sh
sudo ip netns exec host1 ping -c10 192.168.1.20
```

Run an interactive shell and go into the specific namespace.

```sh
sudo ip netns exec switch /bin/bash

# Inside the new terminal
ifconfig

# Or list the MAC ARP table
bridge fdb show
brctl showmacs br0

```
