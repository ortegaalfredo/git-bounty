# git-bounty

Git-bounty is a git plugin that uses the blockchain to implement payments from the git command line, so you can attach bounties to projects and pay them upon completion of a task or issue.

## Installation

You can install it using pip in this way:

    pip install git-bounty

Or manually by placing git-bounty script in the path. No other file is necessary for operation of the plugin.

## Usage:

You manage bounties using several commands:

## create:
Creates a new bounty program.
This command will deploy a new smart contract specific to the current project. After deploying (The network will charge you a small amount) you can upload the gitbounty.ini file to your root directory, so git-bounty can use it to locate the project's bounty database.
Example:

    $ git bounty create "My Project"
    [I] Blockchain connected: True. Your account Balance is 90.288911 Eth
    [I] Creating bounty program for project 'My Project'
    ------ Confirm? [yes/no] yes
    [I] Transaction executed successfully.
    [I] New bounty contract address is 0x300A82d55a119575d3aeCF4Ba64C1EfFFEc04098
    [I] Write new contract info to local config file?
    ------ Confirm? [yes/no] yes
    [I] Done. Don't forget to commit the file gitbounty.ini to your project.

And now you should commit the gitbounty.ini file in your repository, so users can connect to your bounty contract.

## add:
Adds a bounty. Amount is optional.
This creates a new bounty, optionally funding it.
You must have the funds in your local wallet. After creating the bounty, the funds will be transferred to the smart contract and locked there until the bounty is paid, or cancelled.
Example:

    $ git bounty add "Fix issue #43" --amount 15
    [I] Blockchain connected: True. Your account Balance is 90.264176 Eth
    [I] Project name: My Project
    [I] Adding bounty 'Fix issue #43' with amount 15 Eth
    ------ Confirm? [yes/no] yes
    [I] Bounty created successfully. Bounty Id is 1
    [I] Sending 15 Eth to bounty 1
    [I] Transaction executed successfully.


## pay:
Pays a bounty, sending the funds to the specified address.
This command closes the bounty and pays it to the provided address (the address of the bounty hunter that finished the task). Example:

    $ git bounty pay --id 1 --address 0xdb6152646ef1cB4f66c50dcD8B8126B980E5dbAB
    [I] Blockchain connected: True. Your account Balance is 75.261242 Eth
    [I] Project name: My Project
    [I] Paying and closing bounty Id 1, sending funds to 0xdb6152646ef1cB4f66c50dcD8B8126B980E5dbAB:
    Title: Fix issue #43
    Creation: 2023-01-06
    Status: Open
    Amount: 15.00 Eth
    ------ Confirm? [yes/no] yes
    [I] Transaction executed successfully.


## cancel:
Cancels a bounty, returning the funds to contract owner.
This command cancels a bounty, and sends the fund to the project owner. Conceptually its the same as paying it, except its marked as cancelled instead of closed. Example:

    $ git bounty cancel --id 3
    [I] Blockchain connected: True. Your account Balance is 65.253357 Eth
    [I] Project name: My Project
    [E] Address required to return funds (--address)
    [I] Returning funds to owner account (0xdb6152646ef1cB4f66c50dcD8B8126B980E5dbAB)
    [I] Cancelling bounty 3, returning funds to 0xdb6152646ef1cB4f66c50dcD8B8126B980E5dbAB:
    Title: Security audit
    Creation: 2023-01-06
    Status: Open
    Amount: 20.00 Eth
    ------ Confirm? [yes/no] yes
    [I] Transaction executed successfully.


## list:
List all open bounties in the current project.

    $git bounty list -a
    [I] Blockchain connected: True. Your account Balance is 85.251257 Eth
    [I] Project name: My Project
    Id	Created		Title				Status	Amount	Info
    0001	2023-01-06	Fix issue #43			Closed	15.00 Eth
    0002	2023-01-06	Add documentation			Open	5.00 Eth
    0003	2023-01-06	Security audit			Cancelled	 0.00 Eth
    Total bounty funds locked: 20.00 Eth.

## fund:
Send money to an existing bounty.
Any account can fund and existing bounty.
Beware: Funds sent can only be recovered manually by the contract owner by canceling the bounty.

Example:

    $ git bounty fund --id 2 --amount 5
    [I] Blockchain connected: True. Your account Balance is 85.251257 Eth
    [I] Project name: My Project
    [I] Funding bounty 2 with 5 Eth:
    Title: Add documentation
    Creation: 2023-01-06
    Status: Open
    Amount: 5.00 Eth
    ------ Confirm? [yes/no] yes
    [I] Transaction executed successfully.

