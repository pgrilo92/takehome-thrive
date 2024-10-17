# Token Top-Up Processor

This Ruby script processes two JSON files: `users.json` and `companies.json`, to generate an `output.txt` file. It processes users based on their company affiliation, checks their activity status, and applies token top-ups from the company data. Additionally, it handles email notifications based on the user's and company's email settings.

## Features

- **Token Top-Up**: For each active user, the script adds the company-specific token amount to the user's current token balance.
- **Email Notification**: The script records whether an email was sent or not based on the user and company email statuses, but no actual emails are sent.
- **Sorting**: Companies are sorted by `id`, and users are sorted alphabetically by last name in the output.
- **Duplicate ID Checking**: The script checks for duplicate IDs in both the users and companies data, logs the issue, and exits without modifying or removing any data. It assumes the user will handle duplicates externally. Executing this without the loss of potential crucial data.

## Requirements

- Ruby 2.7 or higher

## Files

- `challenge.rb`: The main Ruby script.
- `users.json`: JSON file containing user data.
- `companies.json`: JSON file containing company data.
- `example_output.txt`: Example output to demonstrate expected output format.

## Instructions

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/your-repo/token-top-up-processor.git
   cd token-top-up-processor
   ```

2. **Run the following command**:

   ```bash
   ruby challenge.rb users.json companies.json output.txt
   ```
