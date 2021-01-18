import boto3, jmespath

ec2 = boto3.client('ec2')
response = ec2.describe_instances(InstanceIds=['i-0b30eef81610c55ef'])
print(response)

print(jmespath.search("Reservations[].Instances[].InstanceType", response))
print(jmespath.search("Reservations[].Instances[].KeyName", response))
