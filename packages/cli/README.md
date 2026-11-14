A command-line interface for interfacing with the self-hosted photo manager [Universal Photos](https:///).

Please see the [Universal Photos CLI documentation](https://docs./features/command-line-interface).

# For developers

Before building the CLI, you must build the Universal Photos server and the open-api client. You can use the following command:

    $ mise //:open-api

## Run from build

Go to the cli folder and build it:

    $ pnpm install
    $ pnpm run build
    $ node dist/index.js

## Run and Debug from source (VSCode)

With VScode you can run and debug the Universal Photos CLI. Go to the launch.json file, find the Universal Photos CLI config and change this with the command you need to debug

`"args": ["upload", "--help"],`

replace that for the command of your choice.

## Install from build

You can also build and install the CLI using

    $ pnpm run build
    $ pnpm install -g .
****
