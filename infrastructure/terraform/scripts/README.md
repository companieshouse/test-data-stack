# parameter encryption scripts

## Introduction

These scripts are used to encrypt parameters for use with the AWS parameter store. There are two scripts available to use and each one serves its own purpose.

## Prerequisites

### Software

The scripts have been developed and tested using:

- [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (1.16.11)
- [pip](https://pip.pypa.io/en/stable/installing/) (18.0)
- [python](https://www.python.org/) (2.7.15)

## Variables

Name                    | Description                                                          | Example
----------------------- | -------------------------------------------------------------------- | ------------
key-id                  | The kms key-id used to encrypt your parameter                        | 12a3b456-c7de-89f0-1a2b-345c6de7fab8 (example key)


## Typical operations

There are two scripts available to use for encrypting parameters **encrypt-secret** and **encrypt-secret-with-file**.

Use cases:
- **encrypt-secret** - for the common values (e.g. usernames, passwords, AWS keys).
- **encrypt-secret-with-file** - this should be used for the more complex values (e.g. RSA keys, host_urls)

### encrypt-secret scripts

To run the script you will need to have a valid KMS_KEY_ID which will be used for the encryption of the value. The key-id is input via the command-line via a prompt. You will be prompted to enter your value in the command line. There is a final prompt which asks if the user is happy to proceed with the given key-id and value. The encrypted value is output via the command line when successfully encrypted which you can then use in your Terraform repo containing the secret parameters.

### encrypt-secret-with-file scripts

To run the script you will need to have a valid KMS_KEY_ID which will be used for the encryption of the value. The key-id is input via the command-line via a prompt. A new file is created where the user should input their value and save the file on completion. The user is prompted to confirm if the value is correct before proceeding. There is a final prompt which asks if the user is happy to proceed with the given key-id and value. The encrypted value is output via the command line when successfully encrypted which you can then use in your Terraform repo containing the secret parameters.
