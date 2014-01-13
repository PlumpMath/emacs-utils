## About

Some additional functions for GNU Emacs and various packages for it I
use.  Most of them I wrote myself (they are trivial and I didn't even
bother to search for existing decisions), some I found on the
[wiki](http://www.emacswiki.org/) and in other places.

Every function and variable from this repo has a prefix `utl-`.  It may
look ugly but it makes these packages safe and you can easily try them.
Even if you require every package from this repo, you will see no
difference because none of the original Emacs functionality is changed
(there are some advices, but they are inactive) and none of its
variables is modified.

## Usage

Well, if you find something useful here, you probably know what to do:
just copy a function you like to your `.emacs` (you will surely get rid
of `utl-` prefix) and evaluate it to try it right now.

And now I will tell how I use all these packages.

At first I added a directory with these files to `load-path`:
```lisp
(add-to-list 'load-path "/path/to/emacs-utils")
```

To be able to use functions without requiring everything on emacs start,
I do the following:

- Files with general functions (like `utl-window.el` or `utl-buffer.el`)
  contain autoload cookies for user commands (interactive functions).  I
  generated `utils-autoloads.el` with `M-x update-directory-autoloads`
  and added

  ```lisp
  (require 'utils-autoloads)
  ```

  to `.emacs`.  With that I don't need to require these files.  You can
  read about autoloading in `(info "(elisp) Autoload")`.

- Files for specialized modes (like `utl-dired.el` or `utl-org.el`)
  don't have autoload cookies. For such files I add lines like the
  following to my `.emacs`:

  ```lisp
  (eval-after-load 'gnus '(require 'utl-gnus))
  ```

  And these files are loaded only when they are needed.
