i3-persist(1)
=============


NAME
----
i3-persist - extends i3 window management with persistent containers


SYNOPSIS
--------
[verse]
'i3-persist' lock [<id>]
'i3-persist' unlock [<id>]
'i3-persist' toggle [<id>]
'i3-persist' kill [<id>]


DESCRIPTION
-----------
Closes a container or switches its state from closable to persistent.

Using the featured set of commands, containers can be marked so as to prevent their careless closing. A custom kill command is made available as a plug-in substitute for 'i3-msg kill'. If a container is marked as persistent, attempted closing of the container through the command will have no effect.


SUBCOMMANDS
-----------

lock::
	Marks the container as persistent. Prevent subsequent closes.

unlock::
	Marks the container as closable. Allows the container to be closed.

toggle::
	Toggle the container between the two states.

kill::
	For closable containers, closes the container similarly to 'i3-msg kill'. For persistent containers, doesn't do anything.

By default, i3-persist will operate on the currently focused container. For scripting purposes, it is possible to pass a con\_id to all methods.  


BUGS
----
It is currently possible to close a 
