
Automatically create daily MongoDB backups in Kubernetes.

Configuration options:

- `MONGO_HOST` - service host
- `MONGO_DB` - (optional). Omitting this environment variable will result in the backup of _all_ databases
- `BACKUPS_GS_BUCKET` target Google Cloud storage bucket for backups
