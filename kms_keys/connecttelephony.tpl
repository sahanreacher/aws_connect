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
        } 
    ] 
}