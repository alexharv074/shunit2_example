#!/usr/bin/env bash

script_under_test=$(basename $0)

aws() {
  echo "aws $*" >> commands_log
  case "aws $*" in
    "aws ec2 delete-key-pair --key-name mystack") true ;;
    "aws s3 rm --recursive s3://mybucket/deployments/mystack") true ;;

    "aws cloudformation describe-stack-resources \
--stack-name mystack \
--query "'StackResources[?ResourceType==`AWS::AutoScaling::AutoScalingGroup`].PhysicalResourceId'" \
--output text")
      echo mystack-AutoScalingGroup-xxxxxxxx
      ;;

    "aws autoscaling resume-processes \
--auto-scaling-group-name mystack-AutoScalingGroup-xxxxxxxx")
      true
      ;;

    "aws cloudformation delete-stack --stack-name mystack") true ;;
    *) echo "No response for >>> aws $*" ;;
  esac
}

tearDown() {
  rm -f commands_log
  rm -f expected_log
}

testSimplestExample() {
  . $script_under_test mystack mybucket

  cat > expected_log <<'EOF'
aws ec2 delete-key-pair --key-name mystack
aws s3 rm --recursive s3://mybucket/deployments/mystack
aws cloudformation describe-stack-resources --stack-name mystack --query StackResources[?ResourceType==`AWS::AutoScaling::AutoScalingGroup`].PhysicalResourceId --output text
aws autoscaling resume-processes --auto-scaling-group-name mystack-AutoScalingGroup-xxxxxxxx
aws cloudformation delete-stack --stack-name mystack
EOF

  assertEquals "unexpected sequence of commands issued" \
    "" "$(diff -wu expected_log commands_log)"
}

testBadInputs() {
  actual_stdout=$(. $script_under_test too many arguments passed in)
  assertTrue "unexpected response when passing bad inputs" \
    "echo $actual_stdout | grep -q ^Usage"
}

. shunit2
