# SPDX-License-Identifier: MIT

# Prompt format inspired by the Risto theme (MIT): https://github.com/bruli/oh-my-zsh/blob/master/themes/risto.zsh-theme
# Color computing algorithm loosely ported from roflcat (BSD-3-Clause): https://github.com/jameslzhu/roflcat
# General code structure courtesy of u/romkatv https://www.reddit.com/r/zsh/comments/tganw3/comment/i116ie2

zmodload zsh/mathfunc

local to_color='%n@%m:%2~ $(git_prompt_info)'
local stay_white='%(!.#.$) '
local -E freq=0.1
local -E one_third_pi=1.0472

function set-prompt(){
    # Using $RANDOM always returns the same value for the current term as PROMPT is most likely computed in a zsh subshell.
    # This is intended behaviour -- see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=828180.
    local -i seed="$(shuf -i 0-31415 -n 1) / 1000.0"
    local color colored expanded=${(%%)to_color}
    local -i i r g b n=$#expanded

    for i in {0..$((n - 1))}; do
        val='i + seed'
        r='sin(freq * val) * 127 + 128'
        g='sin(freq * val + 2 * one_third_pi) * 127 + 127'
        b='sin(freq * val + 4 * one_third_pi) * 127 + 127'
        printf -v color '%02x' $r $g $b
        colored+="%F{#$color}${expanded[i+1]:/\%/%%}"
    done

    echo -n "$colored%f${(%%)stay_white}"
}

PROMPT='$(echo $(set-prompt)) '

ZSH_THEME_GIT_PROMPT_PREFIX="‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›"
