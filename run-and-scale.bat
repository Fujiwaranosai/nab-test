docker-compose -f docker-compose.yml -p test up -d backend --scale auth=2 log=2 order=2 product=2 backend=2
