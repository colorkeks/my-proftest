#!/bin/bash
lognumber=$(date +%u)
filename=db_dump$lognumber.sql
pg_dump -U postgres proftest_production > /opt/proftest/backups/$filename
gzip -f /opt/proftest/backups/$filename