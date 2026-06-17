@echo off
echo Backing up Neon database...
"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe" "postgresql://neondb_owner:npg_fbn7wJ2jMOvH@ep-silent-bush-ait93jrv.c-4.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require" --inserts --column-inserts > "C:\Users\tmhan\OneDrive\Desktop\NovaPlate\backend\database-dump.sql"
echo Done! Saved to backend folder.
pause