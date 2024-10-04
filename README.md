# test-workflows
n8n workflows used for testing nodes

## Docker config

Copy `dot-env.example` to `.env` and add the encryption key there. Also make
sure the n8n repository is checked out at `../n8n`. Then you can run the tests
with:


```
COMMAND=test docker compose up --exit-code-from n8n
```

This will create some files and folders in `docker-data/` and an `output/`
folder. The tests will write the results to `output/test-results.json`.

`output/dot-n8n/` will be mounted to `~/.n8n/` and will contain the database,
which is useful for debugging or when you have started the dev-server (see
below).

### Running dev server for creating workflows

The following command will start a dev-server:

```
COMMAND=dev docker compose up --exit-code-from n8n
```

With this server up, you can create your workflows and/or credentials. Then,
with a new terminal, start a session in the container with:

```
docker compose exec n8n /bin/sh
```

This allows you to export workflows to `/output/`:

```
/n8n/packages/cli/bin/n8n export:workflow --backup --id zFePuiBkF9nlktTH --pretty --separate --output /output/workflow
```

This creates the `output/workflow/` directory and exports the workflow
specified there. Any other `n8n` CLI command works similarly.

### Creating snapshots

For snapshot, a separate helper command has been created:

```
COMMAND="snapshot SNAPSHOT_ID" dc up --exit-code-from n8n
```

You can use multiple, comma-separated snapshot ids like so:

```
COMMAND="snapshot 251,252" dc up --exit-code-from n8n
```
