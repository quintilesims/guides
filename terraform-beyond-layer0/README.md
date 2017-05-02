# Terraform beyond Layer0

Please see the official Layer0 [Terraform beyond Layer0 guide](layer0.ims.io/guides/terraform_beyond_layer0/).

### Developer Notes

The Docker repository for this project is `quintilesims/guestbook-db`.
The Docker image can be updated with the following commands:
```
# navigate to the ./src folder

docker build -t quintilesims/guestbook-db .
docker push quintilesims/guestbook-db
```
