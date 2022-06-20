# Terraform CICD Pipeline

This is an example for a CICD pipeline set up with Terraform.

It uses the following AWS services:

- AWS CodeCommit repository
- AWS CodePipeline
- AWS CodeBuild to run tasks for building and testing infrastructure

The code was copied from [here](https://github.com/aws-samples/devsecops-terraform-dojo-codepipeline)

The subfolder's README.md contains comprehensive installation instructions and a detailed explanation about the principles and architecture of the CICD pipeline.

Short setup instructions:

- Start Docker Desktop App
- Install dojo: `brew install kudulab/homebrew-dojo-osx/dojo`
- Set AWS_PROFILE and AWS_DEFAULT_REGION (test with `aws s3 ls`)
- Check that the role you are using for the local deployment includes the permissions from `AWSCodeCommitPowerUser`
- Create AWS CodeCommit repository

```bash
project_name=terraform-dojo-codepipeline
aws codecommit create-repository --repository-name ${project_name}
```

- Copy folder `devsecops-terraform-dojo-codepipeline` outside of the `tfworkshop` parent folder and cd into it. Upload code into CodeCommit repo:

```bash
cp -r devsecops-terraform-dojo-codepipeline ~/temp/.
cd ~/temp/devsecops-terraform-dojo-codepipeline
git init
git add .
project_name=terraform-dojo-codepipeline;git remote add cc-grc codecommit::eu-west-1://${project_name}
git commit -am "initial commit"
git defender --setup
git push -u cc-grc main
```

- Create backend: `./tasks setup_backend`
- Create CICD pipeline: `./tasks setup_cicd`
- Check that pipeline runs successfully in AWS Console
- Change paramter `my_param1` in `./terraform/testing.tfvars`
- Commit and push this change
- Use AWS Console to check that pipeline runs successfully and updates the SSM parameter
- Cleanup:

    ```bash
    MY_ENVIRONMENT=testing ./tasks tf_plan destroy
    MY_ENVIRONMENT=testing ./tasks tf_apply
    MY_ENVIRONMENT=production ./tasks tf_plan destroy
    MY_ENVIRONMENT=production ./tasks tf_apply

    ./tasks setup_cicd destroy
    ./tasks setup_backend destroy
    ```

## Links

- [Original code:](https://github.com/aws-samples/devsecops-terraform-dojo-codepipeline)
- [AWS DevOps blog: Multi-Region Terraform Deployments with AWS CodePipeline using Terraform Built CI/CD](https://aws.amazon.com/blogs/devops/multi-region-terraform-deployments-with-aws-codepipeline-using-terraform-built-ci-cd/)
