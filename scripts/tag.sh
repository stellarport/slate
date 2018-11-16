#call this script: ./scripts/tag.sh version (e.g. ./scripts/tag.sh v1.1.2)

aws s3 sync --delete --profile stellarport dist/ s3://tags.a3s.stellarport.io/$1
