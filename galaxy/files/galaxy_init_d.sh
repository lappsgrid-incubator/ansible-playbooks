#!/bin/bash

### BEGIN INIT INFO
# Provides:             galaxy
# Required-Start:       $network $local_fs $mysql
# Required-Stop:
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Galaxy
### END INIT INFO

case $1 in
    start|stop|restart|status)
        su - galaxy -c "cd /home/galaxy/galaxy && ./run.sh $1"
        ;;
    *)
        echo "Invalid option"
        ;;
esac
