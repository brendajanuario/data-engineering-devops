## Project structure:

### spark_job.py
Script executed in AWS Glue Job that ingests the .csv file from the bucket in the raw directory, applies all the transformations of the requirements and finally saves it in parquet format in the staging directory.

### cognitive-test-content:
Folder with project requirements, input and output data

### infrastructure:
IaC in terraform

### .github/workflows:
CI/CD pipeline configuration from gitHub. Whenever a pull request is requested, the infrastructure is tested, and whenever a merge is made from the develop branch to master, the deploy.
