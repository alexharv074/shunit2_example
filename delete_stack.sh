#!/usr/bin/env bash

usage() {
  echo "Usage: $0 STACK_NAME S3_BUCKET"
  exit 1
}

delete_all_artifacts() {
  aws ec2 delete-key-pair \
    --key-name ${stack_name}
  aws s3 rm --recursive --quiet \
    s3://${s3_bucket}/deployments/${stack_name}
}

resume_all_autoscaling_processes() {
  asgs=$(aws cloudformation describe-stack-resources \
    --stack-name $stack_name \
    --query \
'StackResources[?ResourceType==`AWS::AutoScaling::AutoScalingGroup`].PhysicalResourceId' \
    --output text)

  for asg in $asgs
  do
    aws autoscaling resume-processes \
      --auto-scaling-group-name $asg
  done
}

[ $# -ne 2 ] && usage
read -r stack_name s3_bucket <<< "$@"

delete_all_artifacts
resume_all_autoscaling_processes

aws cloudformation delete-stack \
  --stack-name ${stack_name}
