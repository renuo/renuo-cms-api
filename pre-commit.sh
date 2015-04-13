#!/bin/sh

rubocop
RC=$?
if [ ! $RC -eq 0 ]; then
  echo 'COMMIT ABORTED: Rubocop has detected one or more offences, please review the code and re-commit your changes.'
  exit 1
fi

brakeman
RC=$?
if [ ! $RC -eq 0 ]; then
  echo 'COMMIT ABORTED: Brakeman has detected one or more security vulnerabilities, please review them and re-commit your changes.'
  exit 1
fi

echo '======================================='
echo 'CODE LINTING AND SECURITY CHECK PASSED!'
echo '======================================='
exit 0