# Rule 34 App - Self-Hosted Fork

A Progressive Web App to browse popular Rule 34 Hentai Porn for free.

**This is a self-hosted fork** of the original [Rule 34 App](https://github.com/Rule-34/App) that allows you to run the entire application stack locally on your homeserver, including the database and authentication services.

## Quick Self-Hosted Setup

### Prerequisites
- Docker and Docker Compose installed
- At least 2GB free RAM
- At least 10GB free disk space

### Installation
```bash
# Clone this repository
git clone https://github.com/XargonWan/Rule-34-App-selfhost.git
cd Rule-34-App-selfhost

# Configure environment
cp .env.example .env
# Edit .env file and set your POCKETBASE_ENCRYPTION_KEY
# Optional: Change PORT if you want the app on a different port (default: 3000)

# Start the services
docker-compose up -d
```

### Access
- **App**: http://localhost:${PORT:-3000} (default: http://localhost:3000)
- **PocketBase Admin**: Accessible internally at http://pocketbase:8090/_/ (port not exposed externally for security)

## Online Usage (Original)

If you prefer to use the hosted version instead of self-hosting:

Use the following link to use it on any device that has a _modern_ internet browser.
_This includes Android, iOS, Windows, MacOS, and most consoles like the Play Station and Xbox._

**[✨ https://r34.app ✨](https://r34.app/?utm_source=github&utm_medium=readme)**

## Screenshots

![Posts](https://i.imgur.com/uOiZbXw_d.png?maxwidth=400&fidelity=high) ![Search](https://i.imgur.com/DmsT5TA_d.png?maxwidth=400&fidelity=high)

## Information

### Supported Boorus

This app can browse the following Boorus.

- rule34.xxx
- rule34.paheal.net
- gelbooru.com
- e621.net
- safebooru.org
- e926.net

### Documentation

Links to useful information.

- [Frequently Asked Questions](https://rule34.app/frequently-asked-questions)
- [How to install the App](https://www.installpwa.com/from/r34.app)

## Self-Hosted Features

### Services Included
- **rule34-app**: The main Nuxt.js application (port ${PORT:-3000}) - **EXPOSED** for user access
- **pocketbase**: Local database and authentication service (port 8090) - **INTERNAL ONLY** for security

### Premium Features
Premium features are enabled through user authentication with PocketBase. Users can:
- Save posts across devices
- Access additional booru sites
- Use backup/restore functionality
- Create tag collections

### Data Persistence
- PocketBase data is stored in Docker named volumes for better portability
- All data (database, migrations, public files) is managed by Docker
- To backup your data: `docker-compose exec pocketbase /usr/local/bin/pocketbase backup`
- To restore: `docker-compose exec pocketbase /usr/local/bin/pocketbase restore <backup-file>`
- To view volume data: `docker volume ls` and `docker volume inspect <volume_name>`

## Configuration

### Environment Variables
- `PORT`: Port for the application to run on (default: 3000)
- `POCKETBASE_ENCRYPTION_KEY`: Random string for encrypting sensitive data
- `NODE_ENV`: Set to 'production' for production deployment
- `POCKETBASE_URL`: URL for PocketBase service (internal: http://pocketbase:8090)

### PocketBase Setup
PocketBase is now running internally for security. To access the admin interface:

1. **Temporary access for setup:**
   ```bash
   # Uncomment the ports section in docker-compose.yml
   # ports:
   #   - "8090:8090"
   
   # Then restart services
   docker-compose down && docker-compose up -d
   ```

2. **Access PocketBase admin at:** http://localhost:8090/_/
3. **Create your first superuser account** when prompted by PocketBase

**Important:** PocketBase will show a URL in the logs for creating your first superuser account. Copy that URL and open it in your browser to complete the setup.

**What happens after creating the superuser:**
- PocketBase will be fully set up with an admin account
- You can access the admin panel anytime by temporarily enabling the port
- The app will be able to connect to PocketBase for user authentication and premium features
- Your data will be stored securely in the PocketBase database

**Note:** This is a one-time setup process. Once the superuser is created, PocketBase will remember it for future runs.

Alternatively, you can access PocketBase from within the Docker network:
```bash
# Access PocketBase shell
docker-compose exec pocketbase /bin/sh

# Or run PocketBase commands
docker-compose exec pocketbase /usr/local/bin/pocketbase --help
```

## Social

### Twitter

Follow the Rule 34 App on **[Twitter](https://twitter.com/Rule34App)** for announcements, tips, discount codes and more.

![Twitter badge](https://img.shields.io/twitter/follow/Rule34App?style=for-the-badge)

### Discord

Join the **[Discord](https://discord.gg/fUhYHSZ)** community to keep up with the updates of the project and
receive support.

![Discord badge](https://img.shields.io/discord/656241666553806861?style=for-the-badge)

## Technicalities

### Languages

HTML, CSS, JavaScript, NodeJS.

### Frameworks and tools

NuxtJS, VueJS, TailwindCSS, etc.

Check the [package.json](./package.json) for more information.

## API

This App uses an [API](https://github.com/Rule-34/API) to communicate with all the Boorus.

## Development

### Requirements

- NodeJS >= 20
- NPM
- Docker (for self-hosted development)

### Setup

#### Git Submodules

Use `git clone --recursively` because [this repository](https://github.com/Rule-34/Shared-Resources) is used to share
some necessary resources.

#### Environment variables

```bash
# Modify .env file
cp .env.example .env
```

#### NodeJS Development

```bash
# Install dependencies
npm install

# Serve with hot reload at localhost:3000
npm run dev

# Generate static project
npm run generate
```

#### Docker Development

```bash
# Build and run with Docker Compose
docker-compose up --build
```

For detailed explanation on how things work, check out [Nuxt.js docs](https://nuxtjs.org).

## Security Notes

- ✅ **PocketBase is now internal-only** - No external access to database/API
- Change the default POCKETBASE_ENCRYPTION_KEY to a strong random string
- Use strong passwords for PocketBase admin (when setting up)
- Consider using HTTPS in production with a reverse proxy
- Regularly backup your PocketBase data using the volume management commands
- The main app (port 3000) is the only exposed service for user access

### Security Benefits of Internal PocketBase:
- **Reduced attack surface** - Database not directly accessible from internet
- **All traffic through app** - User requests are validated by the main application
- **Better access control** - PocketBase access controlled by app logic
- **Homeserver-friendly** - Secure for personal server deployments

## Troubleshooting

- **App can't connect to PocketBase**: Check that both services are running with `docker-compose ps`
- **Can't access PocketBase admin**: PocketBase port is not exposed externally for security. See PocketBase Setup section for access instructions
- **PocketBase shows setup URL but can't access it**: Make sure you've uncommented the ports in docker-compose.yml and restarted the services
- **Data not persisting**: Ensure Docker volumes are properly created with `docker volume ls`
- **Port conflicts**: Change the PORT in .env file if port 3000 is already in use
- **Can't access the app**: Make sure the PORT variable matches between .env and docker-compose.yml
- **Volume issues**: Use `docker volume inspect <volume_name>` to check volume status

## Volume Management

### List all volumes
```bash
docker volume ls
```

### Inspect a specific volume
```bash
docker volume inspect rule34-app-selfhost_pocketbase_data
```

### Backup a volume
```bash
# Stop the services first
docker-compose down

# Create backup
docker run --rm -v rule34-app-selfhost_pocketbase_data:/data -v $(pwd):/backup alpine tar czf /backup/pocketbase_backup.tar.gz -C /data .
```

### Restore a volume
```bash
# Stop the services first
docker-compose down

# Remove existing volume
docker volume rm rule34-app-selfhost_pocketbase_data

# Create new volume and restore
docker volume create rule34-app-selfhost_pocketbase_data
docker run --rm -v rule34-app-selfhost_pocketbase_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/pocketbase_backup.tar.gz"
```

### Clean up unused volumes
```bash
docker volume prune
```

## License

This project is a fork of the original Rule 34 App. Please refer to the original repository for licensing information.
