# PGSQL-IO

Create build environment on CentOS 7 (el7) or Rocky Linux 8 (el8)

## 1.) run ./setupInitial.sh to configure OS environment

## 2.) configure your ~/.aws credentials

## 3.) run ./setupBLD-IN.sh to pull in the IN directory from S3

## 4.) Setup Src builds for PGBIN from devel/pgbin/build
       in el7-only:
         + libSrcBuilds.sh
         + gisSrcBuilds.sh
         + buildBoost.sh
         + buildProtobuf.sh
         + buildProtobufc.sh

       + installOracleInstantClient.sh
       + installCppDriver.sh
       sharedLibs.sh
