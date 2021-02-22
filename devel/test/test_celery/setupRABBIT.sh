sudo rabbitmqctl add_user openrds openrds123

sudo rabbitmqctl add_vhost openrds_vhost

sudo rabbitmqctl set_user_tags openrds openrds_tag

sudo rabbitmqctl set_permissions -p openrds_vhost openrds ".*" ".*" ".*"
