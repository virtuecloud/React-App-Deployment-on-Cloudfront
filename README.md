# React App Deployment on Cloudfront 

<h1 align="center"> Virtuecloud </h1> <br>
<p align="center">
  <a href="https://virtuecloud.io/">
    <img alt="Virtuecloud" title="Virtuecloud" src="https://virtuecloud.io/assets/images/VitueCloud_Logo.png" width="450">
  </a>
</p>

## Table of Contents

- [Introduction](#introduction)
- [Feature](#Feature)
- [Inputs](#Inputs)
- [Workflow](#Workflow) 

# Introduction

This repository contains the source code to create a CI/CD pipeline for a React application in AWS. The pipeline pulls the source code from GitHub and run tests against the application to build it before deploying it to an S3 bucket for static site hosting. The site will then be distributed using CloudFront which will point to the S3 bucket.

# Feature

We have used the composite actions here:
   * To build the react app
   * To deploy the build to S3 Bucket
   * To invalidate cache 

 
# Inputs

|Name              |Description|Type|Default|
|------------------|-----------|-------|-------|
|Bucket    |Name of your bucket |string |""|
|Cloudfront_distribution_ID  |Distribution ID of Cloudfront Distribution created  |string |""|

# Workflow

### Step1:
We defined event to run the job when we push the code to the main branch.
### Step2:
Firstly, we defined environment to run the job.
### Step3:
Configured AWS Credentials
### Step4:
Set up the node Environment to run app
### Step5:
Install and build the app
### Step6:
Upload the content of the build folder to S3 bucket
### Step7:
Invalidate the CloudFront distribution to serve the changed file on further requests(every time there is change in the file we need to clear the cache of servers otherwise it will serve old files)

# Usage
```yaml

on:
 push:
    branches:
      - main
jobs:
 build:
   runs-on: ubuntu-latest
   name: to deploy react app
   
   steps:
      
    - name: checkout
      uses: actions/checkout@v1

      
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
          
    - name: Use Node.js
      uses: actions/setup-node@v1
      with:
        node-version: 16.10.0
          
    - name: Build React App
      uses: virtuecloud/Composite-actions/Build/Node@test
      
    - name: Deploy app build to S3 bucket
      uses: virtuecloud/Composite-actions/Deploy/S3@test
      with:
         BUCKET_NAME: ${{ secrets.Bucket }}
         PATH: build/
         
    - name:  Invalidate cache
      uses: virtuecloud/Composite-actions/Deploy/Cloudfront@test
      with:
         AWS_DISTRIBUTION_ID: ${{ secrets.Cloudfront_distribution_ID }}
 
```
