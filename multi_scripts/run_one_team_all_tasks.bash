#!/usr/bin/env bash

# run_one_team_all_tasks.bash: A bash script that calls run_one_team_one_task.bash on all tasks in generated/task_generated
#
# eg. ./run_one_team_all_tasks.bash example_team

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

# Constants.
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NOCOLOR='\033[0m'

# Define usage function.
usage()
{
  echo "Usage: $0 <team_name>"
  exit 1
}

# Call usage() function if arguments not supplied.
[[ $# -ne 1 ]] && usage

TEAM_NAME=$1

task_generated_DIR=${DIR}/../generated/task_generated/

echo -e "
Running all tasks for team: ${TEAM_NAME}"
echo "========================================================="

LIST_OF_TASKS="$(ls $task_generated_DIR)"

successful_team=true
for TASK_NAME in ${LIST_OF_TASKS}; do
  echo "Running task: ${TASK_NAME}..."
  echo "-----------------------------------"
  ${DIR}/run_one_team_one_task.bash "${TEAM_NAME}" "${TASK_NAME}"

  # Check if successful
  if [ $? -ne 0 ]; then
    successful_team=false
  fi

done



# Record team score if all tasks successful
if [ "$successful_team" = true ]; then
  echo "${TEAM_NAME} has completed all tasks. Creating text file for team score"
  python ${DIR}/../utils/get_team_score.py $TEAM_NAME
  exit_status=$?
  
  # Print OK or FAIL message
  if [ $exit_status -eq 0 ]; then
    echo -e "${GREEN}OK.${NOCOLOR}"
  else
    echo -e "${RED}TEAM SCORE TEXT FILE CREATION FAILED: ${TEAM_NAME}${NOCOLOR}" >&2
  fi
else
  echo -e "${TEAM_NAME} has completed all tasks. >=1 task was unsuccessful, so not creating text file for team score${NOCOLOR}" >&2
fi

