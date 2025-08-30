#!/bin/bash

# Ensure we are in the correct directory
cd /Users/umituz/Desktop/Github/umituz/mobile/atomic_flutter

echo "Running Python script to fix relative imports..."
python3 fix_relative_imports.py .

if [ $? -eq 0 ]; then
  echo "Python script executed successfully."
else
  echo "Error: Python script failed to execute."
  exit 1
fi

echo "Cleaning up Python script..."
rm fix_relative_imports.py

echo "Import fix process completed."
