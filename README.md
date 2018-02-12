i3-persist(1)
=============
[![Build Status](https://travis-ci.org/Igrom/i3-persist.svg?branch=master)](https://travis-ci.org/Igrom/i3-persist)

NAME
----
i3-persist - extends i3 window management with persistent containers


SYNOPSIS
--------
i3-persist lock [\<id>]

i3-persist unlock [\<id>]

i3-persist toggle [\<id>]

i3-persist kill [\<id>]


DESCRIPTION
-----------
Closes a container or switches its state from closable to persistent.

Using the featured set of commands, containers can be marked so as to prevent their careless closing. A custom kill command is made available as a plug-in substitute for 'i3-msg kill'. If a container is marked as persistent, attempted closing of the container through the command will have no effect.


INSTALLATION NOTES
------------------
1. Download the repository and save in a catalog.
2. (Optional) Run tests with `./run_tests.sh`.
3. Create a symlink to bin/i3-persist in your PATH.

The tool is the most convenient when used with keybindings.

Example .config/i3/config bindings:
- bindsym $mod+Shift+q exec 'i3-persist kill'
- bindsym $mod+Delete exec 'i3-persist toggle'


SUBCOMMANDS
-----------

`lock`
	Marks the container as persistent. Prevent subsequent closes.

`unlock`
	Marks the container as closable. Allows the container to be closed.

`toggle`
	Toggle the container between the two states.

`kill`
  Closes the container unless either the container or any of its descending containers are locked. Otherwise, doesn't do anything.

By default, i3-persist will operate on the currently focused container. For scripting purposes, it is possible to pass a con\_id to all methods.  


COPYRIGHT
---------
Copyright © 2018 Igor Sowinski.  Licensed under the 3-clause BSD license.
