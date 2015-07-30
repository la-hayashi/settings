# User specific aliases and functions
alias vi="vim"
alias grep="grep --color=auto"
alias ll="ls -al"
alias be="bundle exec"
alias bi="bundle install"
alias rs="bundle exec rake spec SPEC_OPTS=\"-c -fd -fh -o spec/spec_report.html\" RAILS_ENV=test"
alias gt="git"
alias sv="bundle exec rails s"
alias gp="git pull"
alias ex="exit"
alias rspec="bundle exec rspec -c -fd"
alias rebash="exec ${SHELL} -l"
alias mysql='mysql -u root -p'

# Console settings
if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\e[1;33m\]\W\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
