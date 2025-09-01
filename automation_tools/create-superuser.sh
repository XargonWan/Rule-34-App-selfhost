#!/bin/sh

# Create default superuser for PocketBase
echo "👤 Creating default superuser..."

if [ -n "$POCKETBASE_SUPERUSER_EMAIL" ] && [ -n "$POCKETBASE_SUPERUSER_PASSWORD" ]; then
    echo "Email: $POCKETBASE_SUPERUSER_EMAIL"

    # Create the superuser
    if /usr/local/bin/pocketbase superuser upsert "$POCKETBASE_SUPERUSER_EMAIL" "$POCKETBASE_SUPERUSER_PASSWORD"; then
        echo "✅ Superuser created successfully!"
        echo "⚠️  IMPORTANT: Change the password '$POCKETBASE_SUPERUSER_PASSWORD' after first login!"
    else
        echo "ℹ️  Superuser may already exist"
    fi
else
    echo "ℹ️  No superuser credentials provided"
fi

echo ""
