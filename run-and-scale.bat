docker-compose -f docker-compose-scale.yml -p test up -d --scale auth-scale=2 --scale log-scale=2 --scale order-scale=2 --scale backend-scale=2
