#!/bin/bash
APP_ROOT="/home/`whoami`/capistrano/current"
export basename="rake_lti_showcase_participant_import"

if [ -f ~/batches/pids/$basename.pid ]; then
  echo [rake_jobs_workoff]$basename is working now. >> /home/`whoami`/capistrano/current/log/batch_production_rotate.log
  exit 0
fi

mkdir -p ~/batches/pids
echo $$ > ~/batches/pids/$basename.pid

source ~/.bash_profile
cd ${APP_ROOT}

rake RAILS_ENV=production RBASE_LOG_NAME=batch_production lti:import_lti_showcase_partificants[showcase_participant.xlsx]
rake_exit_code=$?

rm -f ~/batches/pids/$basename.pid
exit $rake_exit_code
