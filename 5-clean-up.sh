#!/bin/bash
# Remove all working folders and tmp files
set -e
echo ---------------------------CLEAN_UP-------------------------------
#ORG_MODEL="model"
ADAPT_FOLDER="adapt"
WORK_DIR="work"
NEW_MODEL_FOLDER="adapted_model"
NEW_MODEL_ZIP="adapted_model.zip"
if [ -d "$ADAPT_FOLDER" ]; then rm -r "$ADAPT_FOLDER"; fi
if [ -d "$WORK_DIR" ]; then rm -r "$WORK_DIR"; fi
if [ -f "$NEW_MODEL_ZIP" ]; then rm "$NEW_MODEL_ZIP"; fi
if [ -d "$NEW_MODEL_FOLDER" ]; then
	cd $NEW_MODEL_FOLDER
	zip -r ../$NEW_MODEL_ZIP *
	cd ..
	rm -r "$NEW_MODEL_FOLDER"; 
fi
