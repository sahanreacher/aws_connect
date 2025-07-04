{ 
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [ 
        { 
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": { 
                "AWS": "arn:aws:iam::${account_id}:root" 
            },
            "Action": "kms:*",
            "Resource": "*" 
        },
        { 
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": { 
                "AWS": "arn:aws:iam::${account_id}:role/aws-service-role/connect.amazonaws.com/AWSServiceRoleForAmazonConnect" 
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ], 
            "Resource": "*"
        },
        { 
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": { 
                "AWS": "arn:aws:iam::${account_id}:role/aws-service-role/connect.amazonaws.com/AWSServiceRoleForAmazonConnect" 
            },
            "Action": [ 
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": { 
                "Bool": { 
                    "kms:GrantIsForAWSResource": "true" 
                } 
            } 
        } 
    ] 
}