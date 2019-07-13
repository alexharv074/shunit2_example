#!/usr/bin/env bash

script_under_test=$(basename "$0")

setUp() {
  . placebo
  pill_attach "command=aws" "data_path=shunit2/fixtures"
  pill_playback
}

tearDown() {
  rm -f expected_log actual_log
}

testSimplestExample() {
  . "$script_under_test" 'mystack' 'mybucket'

  cat > expected_log <<'EOF'
aws ec2 delete-key-pair --key-name mystack
aws s3 rm --recursive --quiet s3://mybucket/deployments/mystack
aws cloudformation describe-stack-resources --stack-name mystack --query StackResources[?ResourceType==`AWS::AutoScaling::AutoScalingGroup`].PhysicalResourceId --output text
aws autoscaling resume-processes --auto-scaling-group-name mystack-AutoScalingGroup-DNJNP204KFSD
aws cloudformation delete-stack --stack-name mystack
EOF
  pill_log > actual_log

  assertEquals "unexpected sequence of commands issued" \
    "" "$(diff -wu expected_log actual_log)"

  pill_detach
}

testBadInputs() {
  actual_stdout=$(. "$script_under_test" 'too' 'many' 'arguments' 'passed' 'in')
  assertTrue "unexpected response when passing bad inputs" \
    "echo $actual_stdout | grep -q ^Usage"

  pill_detach
}

testNoASGs() {
  . "$script_under_test" 'myotherstack' 'mybucket'
  assertFalse "a resume-processes command was unexpectedly issued" \
    "pill_log | grep resume-processes"

  pill_detach
}

. shunit2
