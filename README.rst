Tog test online
===============

Tog test online is a simple self test of Bruce Tognazzini's findings about a mouse being faster than
a keyboard. Try it out at http://togonline.bitbucket.org/.

Getting started
---------------

Fork this repository and point your favorite Web server at the directory.

Dependencies
------------

* `jQuery <http://jquery.com>`_
* `CoffeeScript <http://coffeescript.org>`_
* `Bacon Ipsum <http://baconipsum.com>`_

Spec
----

This facilitates testing yourself with keyboard speed versus mouse speed according to Tog's
description. It does not record your scores or try to prevent cheating in any way.

Target browsers:

* Internet Explorer 9+
* Chrome
* Firefox

Text entry
^^^^^^^^^^

The page contains two text areas. Each area contains random text where letter e has been replaced by
pipes. Though random, each text area contains the same text.

One text area does not allow the user to navigate with the keyboard, forcing mouse use only. It does
this by disabling some keys:

* Cursor keys
* Backspace
* Delete

The second text area enforces keyboard-only navigation. It does this by hiding the mouse cursor
when the cursor is over it, making mouse navigation impractical.

Starting the test
^^^^^^^^^^^^^^^^^

When the page loads, the text areas will not be editable. The text area font size will start very 
large to emphasize that the system has already selected the first pipe in the text for the user.

When pressed, a test start button does the following:

* Disables option settings, if necessary
* Enables its associated test text area
* Ensures that the first pipe is selected and the text area has focus
* Zooms the text down to the size specified for the test

The start button does not actually start the test timer. Time does not start until the user replaces
the first pipe or makes presses some other key in the now-activated text area.

Users may begin with either test they please. Nothing prevents them from running both at the same 
time, though I fail to see why they would do so.

Help (todo)
^^^^

Early usability testing revealed that people will not bother to carefully read the description, or 
even the instructions written on the start button, save, presumablye "click when ready." At this
point, users, falsly thinking themselves ready, become baffled and irate at their lack of ability to
use cursor keys.

Top men evaluated many possible solutions to this problem and estimate that best option to be
addition of a help feature. Though many rightly deride help features as cowardly patches on failed
user interfaces, in this case, careful consideration determined a help feature to be the appropriate
remedy. This test by nature must violate user expectations and no amount of instruction, however
concisely presented, it was reasoned, would mitigate the human tendency to ignore said instructions.

The feature will, therefore, appear in the moment of greatest peril, when the users, having
blundered ill-prepared into the test find themselves helpless to complete its objective, the system
shall present to them, in close proximity to the test text area, a button.

Said button shall prominenently display the label "help." Its caption should be carefully worded to
empathize with the user's state of mind and imply that they are not alone in helplessness.
Suggested wording for such a caption includes "I can't edit this?" "Why the hell can't I edit this?"
and "I can't edit this shit!"

TODO: describe the how this feature works

Ending the test
^^^^^^^^^^^^^^^

The test automatically ends once the user has replaced every pipe in the text. Once done, the system
starts a three second countdown, which allows the user to correct any errors they made. For example,
they may have inadvertently replaced two characters when they meant to replace one, and wish to put
the old character back. Each keypress in the textarea restarts the three second countdown.

When the countdown expires, the system calculates the time the user spent on the test. The end time
will be the time of the last keystroke, not the end of the countdown. The system also calculates
number of errors in the completed text as compared to the original; it then displays the time
elapsed, number of pipes replaced and number of errors.

Once completed, the user cannot take the test again without a complete reset.

Options
^^^^^^^

The page allows the user to choose whether the test text should be proportional or monospace and
whether the font size should be normal or large. It only allows setting these options prior to 
starting the test.

Reset (todo)
^^^^^

Refreshing the page or clicking a reset button will reset the test. These two actions should be
identical. In particular, they will both:

* Generate new random text
* Preserve the user's previously chosen options, for the same window and browser session
