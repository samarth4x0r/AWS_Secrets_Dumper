# AWS_Secrets_Dumper



## Getting started

NCC's ScoutSuite seems to prevent environment variables associated with Lambda functions, which can contain secrets/other sensitive info to be flagged for "security" and "privacy" reasons. So I went down a rabbit hole to try and automate this to avoid missing this in future engagements.

Also, seems like the EC2 instance metadata fetched and returned by ScoutSuite is unreadable and gibberish. The `ec2_metadata_fetch.sh` script should deal with this.


## Usage


### BashDigger.sh (If you have IAM Access Keys)

1. The BashDigger.sh script is far simpler and just uses the AWS CLI to fetch and output info.

2. Save your AWS Keys under a recognisable profile name such as:
```
(...SNIP...)
[DEMO_USER_AWS_SECURITY_ANALYST]
aws_access_key_id=ASIAXXXXXXXXXXXXXXXXXXX
aws_secret_access_key=ZXXXXXXXXXXXXXXXXXXXXXXXXXXXX
aws_session_token=IXXXXXXXXXXXXXXXXX...
(...SNIP...)
```
3. ```chmod +x BashDigger.sh```

4. ```./BashDigger.sh <profile_name> <region>```

5. The region parameter is optional. If unsure, leave it out, the script will iterate through all possible regions.


### ScoutDigger.py (If you are only working with ScoutSuite output)
The ScoutDigger.py script requires some modifications to be made:

1. Under scoutsuie-report/scoutsuite-results, find the "results.js" file.

2. You'll notice this is just a JSON file except for the first line, i.e. "scoutsuite_results =". Delete this line and save the file as a .json file.

3. Run the ScoutDigger.py script against the JSON file: ```python ScoutDigger.py /path/to/file.json```


### ec2_metadata_fetch.sh

1. chmod +x `ec2_metadata_fetch.sh`.

2. ./ec2_metadata_fetch.sh <<AWS_PROFILE>> <<AWS_REGION>>.

