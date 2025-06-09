#!/bin/bash
set -euo pipefail

BLUE='\033[1;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Restarting chronyd...${NC}"
sudo systemctl restart chronyd

echo -e "${BLUE}Forcing immediate time sync with 'chronyc makestep'...${NC}"
sudo chronyc makestep

echo -e "${BLUE}Checking new system time drift...${NC}"
chronyc tracking

echo -e "${BLUE}Verifying AWS credentials (sts get-caller-identity)...${NC}"
if aws sts get-caller-identity > /dev/null 2>&1; then
  echo -e "${GREEN}[✔] AWS credentials are now valid. Time is synced.${NC}"
else
  echo -e "${RED}[✘] AWS authentication still failing. Check your credentials or session.${NC}"
  exit 1
fi