case "aws $*" in

  # responses for mystack.
  "aws ec2 delete-key-pair --key-name mystack") true ;;
  "aws s3 rm --recursive --quiet s3://mybucket/deployments/mystack") true ;;

  "aws cloudformation describe-stack-resources \
--stack-name mystack \
--query "'StackResources[?ResourceType==`AWS::AutoScaling::AutoScalingGroup`].PhysicalResourceId'" \
--output text")
    cat <<'EOF'
mystack-AutoScalingGroup-DNJNP204KFSD
EOF
    ;;

  "aws autoscaling resume-processes \
--auto-scaling-group-name mystack-AutoScalingGroup-DNJNP204KFSD") true ;;

  "aws cloudformation delete-stack --stack-name mystack") true ;;

  # responses for myotherstack.
  "aws ec2 delete-key-pair --key-name myotherstack") true ;;
  "aws s3 rm --recursive --quiet s3://mybucket/deployments/myotherstack") true ;;

  "aws cloudformation describe-stack-resources \
--stack-name myotherstack \
--query "'StackResources[?ResourceType==`AWS::AutoScaling::AutoScalingGroup`].PhysicalResourceId'" \
--output text")
    echo ""
    ;;

  "aws cloudformation delete-stack --stack-name myotherstack") true ;;

  *)
    echo "No responses for: aws $*"
    ;;
esac
