#call this script: ./scripts/deploy.sh env domain (e.g. ./scripts/deploy.sh production stellarport.io)

aws s3 sync --profile stellarport --acl public-read --delete build/ s3://a3s.stellarport.io
aws s3 cp --profile stellarport --acl public-read --cache-control 'max-age=0' build/index.html s3://a3s.stellarport.io/index.html
