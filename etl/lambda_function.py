import boto3

def handler(event, context):
    """
    Lambda function that starts a job flow in EMR.
    """
    client = boto3.client('emr', region_name='us-east-2')

    cluster_id = client.run_job_flow(
        Name='igti-emr',
        ServiceRole='igti-emr-role',
        JobFlowRole='igti-emr-ec2-role',
        VisibleToAllUsers=True,
        LogUri='s3://igti-datalake-atheobaldo/emr-logs',
        ReleaseLabel='emr-6.3.0',
        Instances={
            'InstanceGroups': [
                {
                    'Name': 'Master nodes',
                    'Market': 'SPOT',
                    'InstanceRole': 'MASTER',
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 1,
                },
                {
                    'Name': 'Worker nodes',
                    'Market': 'SPOT',
                    'InstanceRole': 'CORE',
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 1,
                }
            ],
            'Ec2KeyName': 'igti-atheobaldo-key-pair',   
            'KeepJobFlowAliveWhenNoSteps': True,
            'TerminationProtected': False,
            'Ec2SubnetId': 'subnet-5b551a17'       # ${aws_subnet.main.id}  
        },

        Applications=[
            {'Name': 'Spark'},
            {'Name': 'Hive'},
            {'Name': 'Pig'},
            {'Name': 'Hue'},
            {'Name': 'JupyterHub'},
            {'Name': 'JupyterEnterpriseGateway'},
            {'Name': 'Livy'},
        ],

        Configurations=[{
            "Classification": "spark-env",
            "Properties": {},
            "Configurations": [{
                "Classification": "export",
                "Properties": {
                    "PYSPARK_PYTHON": "/usr/bin/python3",
                    "PYSPARK_DRIVER_PYTHON": "/usr/bin/python3"
                }
            }]
            },
            {
                "Classification": "spark-hive-site",
                "Properties": {
                    "hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
                }
            },
            {
                "Classification": "spark-defaults",
                "Properties": {
                    "spark.submit.deployMode": "cluster",
                    "spark.speculation": "false",
                    "spark.sql.adaptive.enabled": "true",
                    "spark.serializer": "org.apache.spark.serializer.KryoSerializer"
                }
            },
            {
                "Classification": "spark",
                "Properties": {
                    "maximizeResourceAllocation": "true"
                }
            }
        ],
                
        StepConcurrencyLevel=1,
        
        Steps=[{
            'Name': 'Tratamento',
            'ActionOnFailure': 'CONTINUE',
            'HadoopJarStep': {
                'Jar': 'command-runner.jar',
                'Args': ['spark-submit',
                        '--master', 'yarn',
                        '--deploy-mode', 'cluster',
                        's3://igti-datalake-atheobaldo/emr-code/pyspark/job_tratamento.py'
                        ]
            }
        }],
    )

    return {
        'statusCode': 200,
        'body': f"Started job flow {cluster_id['JobFlowId']}"
    }