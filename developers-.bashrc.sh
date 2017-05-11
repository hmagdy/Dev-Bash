SUFFIX=".git"
BRANCH=""

function GET_GIT_BRANCH ()
{
    ARG=$1
    if [ ! ${#ARG} -lt 4 ]; then
        if [ ! -d "$ARG$SUFFIX" ]; then
            BRANCH=""
            ARG=`echo $ARG | sed -e "s|[^\/]*\/$||g"`
            GET_GIT_BRANCH "$ARG"
        else
            CMD=`git branch | grep \* | sed -e "s|\* ||"`
            BRANCH=" [$CMD]"
        fi
    fi
}


function GET_SVN_BRANCH () {
    if [ -d ".svn" ]; then
        BRANCH=" [`svn info | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$'`]"
    fi

    if [ ${#BRANCH} -lt 4 ]; then
        BRANCH=""
    fi
}

function pretty_prompt () {
	_IFS=$IFS;
	DIR=`pwd|sed -e "s|$HOME|~|"`;
	IFS="/" && S=($DIR);
	L=${#S[@]};
	IFS=$_IFS;
	if [ $L -gt 4 ]; then 
		DIR="${S[0]:0:1}/${S[1]}/../${S[$L-2]}/${S[$L-1]}";
	fi

    # set $BRANCH variable as git branch name
    GET_GIT_BRANCH `pwd`"/"
    # set $BRANCH variable as svn branch name
    GET_SVN_BRANCH
}


PROMPT_COMMAND=pretty_prompt;
export PS1="\[\e[32;1m\]\u@\$DIR\[\e[33;1m\]\$BRANCH\[\e[0m\]\[\e[32;1m\] \$ \[\e[0m\]\[\e[0m\]"

