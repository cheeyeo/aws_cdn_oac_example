### AWS CDN Example

Example Terraform modules of setting up a Cloudfront CDN to access files stored in private s3 bucket.

The assets are only accessible via the CDN through an Origin Access Control ( OAC ) to prevent bypass of the CDN. Access to S3 is only permissible via the CDN as defined in the S3 Bucket Policy/

The CDN also has a cache policy applied that supports both GZIP and Brotoli compression.


### To run

```
terraform init

terraform plan -var-file='inputs.tfvars' -out=tfplan

terraform apply -var-file='inputs.tfvars' tfplan
```

Example inputs.tfvars file:
```
aws_s3_bucket     = "private_s3bucket"
aws_s3_log_bucket = "cdn_log_bucket"
aws_region        = "eu-west-1"
prebuilt_policy_name = "Managed-CachingOptimized"
```

If `prebuilt_policy_name` is set, it will the specified policy as defined by Cloudfront. If left blank, it will use the policy defined in `cache_policy.tf`



### Refs

https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html


https://www.if-not-true-then-false.com/2010/curl-tip-check-that-the-apache-compression-gzip-deflate-is-working/


https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-troubleshoot-compressed-files/

https://aws.amazon.com/blogs/aws/amazon-s3-encrypts-new-objects-by-default/


### Checking the compression headers

Only check the headers:
```
export CDN="https://XXXX.cloudfront.net"

curl -v -I -H "Accept-Encoding: br,gzip,deflate" ${CDN}/file

```

To invalidate cache:
```
aws cloudfront create-invalidation --distribution-id XXXX --paths "/*"
```