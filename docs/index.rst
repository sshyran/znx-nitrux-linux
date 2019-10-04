.. ZNX documentation master file, created by
   sphinx-quickstart on Thu Oct  3 17:05:41 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to ZNX's documentation!
===============================

This document is targeted for both users wanting to use ZNX as well as developers
trying to integrate ZNX as a backend to other applications.

----

.. ........................................

.. toctree::
   :maxdepth: 3
   :caption: Table of Contents:

   obtaining_znx
   usage_guide

.. ........................................

----

What is ZNX ?
^^^^^^^^^^^^^

ZNX is an operating system manager; a tool that lets you deploy operating systems
as single-file ISO images; as well as keeping them updated. It also supports rollbacks
and hard-resets.

Why ZNX ?
^^^^^^^^^
At Nitrux, we wanted a way to provide safe updates and ensure the stability of the
operating system, and at the same time, we wanted to keep it out of the way of the
user. This can be resumed in one phrase: simplicity and reliability.

So our solution was this:

* Keep each operating system in its original ISO image.
* Allow rollbacks after updates.
* Support hard-resets (i.e. delete all user data), allowing the system to be restored
  to a pristine state.
* Mount the user data as overlays.

This means that the operating system is managed as an integral unit, and not as smaller
parts of a greater whole. Also, bandwidth usage is greatly reduced by the means of
differential updates. When updating, the operation is atomic, which means that it will
only succeed (the update is applied) or fail (the system is left untouched).
Rollbacks allow reverting updates. Hard-resets allow having pristine images at any moment.


.. ........................................

.. LINKS
.. _Nitrux: http://nxos.org

.. ........................................


.. ........................................

.. Indices and tables
.. ==================

.. * :ref:`genindex`
.. * :ref:`modindex`
.. * :ref:`search`

.. ........................................