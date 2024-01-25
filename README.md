# Sagemaker Stop All Apps Lambda

Lambda to iterate through all sagemaker user profiles and stop all apps. Useful for things like updating LCCs.

# CI

Continuous Integration is run through GitHub actions in [ci.yml](./.github/workflows/ci.yml) on PR to `main` where we lint, test and plan out infrastructure resources. We add a PR comment to show the results of our Terraform efforts to plan our infrastructure.

# CD

Continuous Delivery is run through GitHub actions in [cd.yml](./.github/workflows/cd.yml) on push to `main` branch.
