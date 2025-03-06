
# AWS Account Setup and IAM Configuration

This guide provides step-by-step instructions to create an AWS account, set up a billing alarm, create IAM groups and users, and test their permissions.

## Create a Billing Alarm

1. **Go to Billing and Management.**
   ![Bill](./assets/Bill%20Management.png)

2. **Select Budgets from the left sidebar.**
   ![Budgets](./assets/Budgets.png)

3. **Click on Create Budget.**
   ![Create](./assets/create%20budget.png)

4. **Choose Budget Type.** Here, we will use the zero spend budget template that will notify us when we exceed the free tier limits.
   ![Budget Setup](./assets/budget-setup.png)

5. **Specify the budget template name and email recipients.**
   ![Email](./assets/email-recipients.png)

6. **You can now see the recently created budget.**
   ![Result](./assets/budget-result.png)

## Create Users and Groups

### Create 2 IAM Groups (admin, developer)

1. **Go to the IAM Dashboard.**
   ![IAM Dashboard](./assets/IAM-Dashboard.png)

2. **Select User groups from the left sidebar.**
   ![User Groups](./assets/user-groups.png)

3. **Click on Create group.**
   ![Create Group](./assets/create-group.png)

4. **Specify a name for the group, in our case, "admin".**
   ![Group Name](./assets/group-name.png)

5. **Attach the Administrator policy to the group.**
   ![Policy](./assets/admin-group-policy.png)

6. **Create another group named "developer".**
   ![Dev Group](./assets/dev-group.png)

7. **Attach Permissions (EC2 Full Permissions) to the developer group.**
   ![EC2 Permissions](./assets/ec2-permissions.png)

8. **Now we have 2 IAM groups: the Admin group with admin permissions and the Developer group with EC2 access.**
   ![Groups Result](./assets/groups-result.png)
   ![Developer Group](./assets/dev-group-result.png)

### Create 2 Users: admin-1 with console access only and MFA, and admin-2-prog with CLI access only

#### admin-1 Creation

1. **Go to the IAM Dashboard.**
   ![IAM Dashboard](./assets/IAM-Dashboard.png)

2. **Select Users from the left sidebar.**
   ![User Groups](./assets/user-groups.png)

3. **Click on Create user.**
   ![Create User](./assets/create-user.png)

4. **Specify user details.** Ensure to select "Provide user access to the AWS Management Console" for the admin-1 user and "I want to create an IAM user".
   ![User Details](./assets/user-1-details.png)
   Then click Next.

5. **Set permissions.**
   ![Admin Permissions](./assets/user-1-permissions.png)

6. **Review your steps and click Create.**
   ![Review Admin](./assets/review-user-1.png)

7. **After successfully creating the admin-1 user, save the user password for the next login.** Note: This password is for one-time use only and you will be required to change it upon the next login.
   ![User Password](./assets/user-1-password.png)

8. **admin-1 user summary.**
   ![Admin Summary](./assets/user-1-summary.png)

#### admin-1 Enable MFA

1. **In the admin-1 screen, go to Multi-factor authentication and choose Assign MFA device.**
   ![Admin MFA](./assets/user-1-MFA.png)

2. **Specify the MFA name and device option.**
   ![Admin MFA Select](./assets/user-1-MFAInfo.png)

3. **Set up the device using any compatible application like Google Authenticator or Authy.** Scan the QR code and enter the codes from the application.
   ![Admin MFA Setup](./assets/user-1-MFASetUp.png)

#### admin-2-prog Creation

1. **Select Users from the left sidebar.**
   ![User Groups](./assets/user-groups.png)

2. **Click on Create user.**
   ![Create User](./assets/create-user.png)

3. **Specify user details.** This time, do not select "Provide user access to the AWS Management Console" because we need CLI access only for admin-2-prog.
   ![Admin 2](./assets/user-2-details.png)

4. **Set permissions.**
   ![Admin Permissions](./assets/user-1-permissions.png)

5. **Review your steps and click Create.**
   ![Review Admin](./assets/review-user-2.png)

6. **Now we have created 2 groups with 2 admin users.**
   ![Users Summary](./assets/admin-users-summary.png)

### Create Access Key for admin-2-prog

1. **Go to the admin-2-prog user details and create an access key.**
   ![Access Key](./assets/user-2-access-key.png)

   **Don't forget to save your Access keys in a safe place.**

## Test admin-2-prog

1. **We need a machine with AWS CLI installed.**

2. **Configure your CLI with the newly created user:**
    ```sh
    aws configure --profile admin-2-prog
    ```
Or modify the credentials file:
    ```sh
    vi ~/.aws/credentials

    add
    [admin-2-prog]
    aws_access_key_id = YOUR_ACCESS_KEY_ID
    aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
    ```

3. Verify the new configuration:
```sh
aws configure list-profiles
```
You will see the newly added user.

4. Test admin-2-prog user:
```sh
aws iam list-groups --profile=admin-2-prog
aws iam list-users --profile=admin-2-prog
```
![List Groups](./assets/list-groups.png)
![List Users](./assets/list-users.png)

## Create dev-user with CLI and console access

1. Follow the admin-1 creation steps and change the required parameters:
    - Name: dev-user
    - Group: Developer

## Login to dev-user and test the assigned permissions

1. Go to the EC2 Dashboard and try to list and see the instances. You will see that you have permissions to use all EC2 features.

2. Go to the S3 Dashboard. You will get an Access Denied error due to lack of permissions.
![S3 Access](./assets/access-s3.png)

