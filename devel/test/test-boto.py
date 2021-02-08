import boto3, jmespath

ec2 = boto3.client('ec2')
response = ec2.describe_security_groups()
for sg in response['SecurityGroups']:
  dict = {}
  dict['name'] = sg['GroupName']
  dict['id']  = sg['GroupId']
  #print("DEBUG: sg.GroupName = " + str(sg['GroupName']))
  for ipp in sg['IpPermissions']:
    for r in ipp['IpRanges']:
      dict['cidr'] = str(r['CidrIp'])
      ##print(str(r['CidrIp']))
      break
    dict['port'] = str(ipp['FromPort']) + ":" + str(ipp['ToPort'])       
    #print(str(ipp['FromPort']) + "\n")
    break

  print(str(dict))

#response = ec2.describe_instances(InstanceIds=['i-0b30eef81610c55ef'])
#print(response)

#print(jmespath.search("Reservations[].Instances[].InstanceType", response))
#print(jmespath.search("Reservations[].Instances[].KeyName", response))
