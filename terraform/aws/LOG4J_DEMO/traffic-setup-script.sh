#!/bin/bash

cat > drive_traffic.sh << 'EOFBASH'
#!/bin/bash
while :
do
  curl http://${IP_A}:8080/tweets
  curl http://${IP_B}:8080/tweets
  sleep 1
done
EOFBASH

chmod +x drive_traffic.sh
nohup ./drive_traffic.sh &