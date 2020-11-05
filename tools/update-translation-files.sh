# Usage:
#   ./tools/$script_name [ALL|translation file]

set -eu -o pipefail

readonly COMMIT_MSG="chore(i18n): update translation files"
readonly LUPDATE_CMD="lupdate qml -no-obsolete -locations none -ts"

if [[ "$@" = "ALL" ]]
then
    for translation in translations/*.ts
    do
        $LUPDATE_CMD "$translation"
    done
else
    $LUPDATE_CMD "$@"
fi
