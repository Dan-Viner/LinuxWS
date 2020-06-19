# add git branch name to PS1

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

DEFAULT_PROMPT="\[\e[01;95m\]\t \[\e[01;32m\]\u@\h\[\e[00m\]:"
WORKING_DIR="\[\e[01;34m\]\w"
GIT_BRANCH="\[\e[01;93m\]\$(parse_git_branch)"
DEFAULT_COLOR="\[\e[00m\]"
TAB_TITLE="\[\e]2;Terminal\a\]"

PS1="${DEFAULT_PROMPT}${WORKING_DIR}${GIT_BRANCH}${DEFAULT_COLOR}$ ${TAB_TITLE}"
