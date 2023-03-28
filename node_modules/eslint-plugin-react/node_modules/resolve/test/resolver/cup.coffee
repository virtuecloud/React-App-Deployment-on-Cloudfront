on:
  workflow_dispatch:

jobs:
 build:
   runs-on: ubuntu-latest
   name: to build react app
   
   steps:
      
    - name: checkout
      uses: actions/checkout@v2

      
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
        
    - name: build app
      uses: virtuecloud/Composite-actions/Build/Node@test
                
     
    - name: Deploy static site to S3 bucket
      run: aws s3 sync build/ s3://flask-buckett --delete 
      
 deploy:
   runs-on: ubuntu-latest
   name: to deploy react app
   needs: build
   
   steps:
      
    - name: checkout
      uses: actions/checkout@v2

      
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
     
    - name: Deploy to ec2
      run: aws ssm send-command --document-name "AWS-RunRemoteScript" --instance-ids "i-0fe4812c72084796b" --parameters '{"sourceType":["S3"],"sourceInfo":["{\"path\":\"https://flask-buckett.s3.us-east-1.amazonaws.com\"}"],"commandLine":["serve -s build"],"workingDirectory":["/home/ubuntu"]}'

          
    
