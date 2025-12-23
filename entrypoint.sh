#!/bin/bash

set -e

echo "Waiting for database..."
until nc -z db 5432; do
  sleep 2
done

echo "Running migrations..."
python manage.py makemigrations
python manage.py migrate

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting Gunicorn server..."
exec gunicorn conduit.wsgi:application --bind 0.0.0.0:8000
