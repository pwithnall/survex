#!/bin/sh
#
# Survex test suite - smoke tests
# Copyright (C) 1999-2003,2005,2011,2012,2014 Olly Betts
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

testdir=`echo $0 | sed 's!/[^/]*$!!' || echo '.'`

test -x "$testdir"/../src/cavern || testdir=.

# Ensure that --version and --help work without an X display.
DISPLAY=
export DISPLAY

PROGS="cad3d cavern diffpos extend sorterr 3dtopos aven"

vgrun=
vg_error=123
vg_log=vg.log
if [ -n "$VALGRIND" ] ; then
  rm -f "$vg_log"
  vgrun="$VALGRIND --log-file=$vg_log --error-exitcode=$vg_error"
fi

for p in ${PROGS}; do
  echo $p
  for o in version help ; do
    if test -n "$VERBOSE"; then
      $vgrun "$testdir/../src/$p" --$o
      exitcode=$?
    else
      $vgrun "$testdir/../src/$p" --$o > /dev/null
      exitcode=$?
    fi 2> stderr.log
    if [ -s stderr.log ] ; then
      echo "$p --$o produced output on stderr:"
      cat stderr.log
      rm stderr.log
      exit 1
    fi
    rm stderr.log
    if [ -n "$VALGRIND" ] ; then
      if [ $exitcode = "$vg_error" ] ; then
	cat "$vg_log"
	rm "$vg_log"
	exit 1
      fi
      rm "$vg_log"
    fi
    [ "$exitcode" = 0 ] || exit 1
  done
done

: ${AVEN="$testdir"/../src/aven}

# Regression test - aven in 1.2.6 segfaulted here:
echo "SURVEXLANG=nosuch aven"
if test -n "$VERBOSE"; then
  SURVEXLANG=nosuch $vgrun "$testdir/../src/aven"
  exitcode=$?
else
  SURVEXLANG=nosuch $vgrun "$testdir/../src/aven" >/dev/null
  exitcode=$?
fi 2>/dev/null
if [ -n "$VALGRIND" ] ; then
  if [ $exitcode = "$vg_error" ] ; then
    cat "$vg_log"
    rm "$vg_log"
    exit 1
  fi
  rm "$vg_log"
fi
[ "$exitcode" = 1 ] || exit 1

# Regression test - aven in 1.2.6 segfaulted here:
echo "SURVEXLANG= LANG=nosuch aven"
if test -n "$VERBOSE"; then
  SURVEXLANG= LANG=nosuch $vgrun "$testdir/../src/aven"
  exitcode=$?
else
  SURVEXLANG= LANG=nosuch $vgrun "$testdir/../src/aven" >/dev/null
  exitcode=$?
fi 2>/dev/null
if [ -n "$VALGRIND" ] ; then
  if [ $exitcode = "$vg_error" ] ; then
    cat "$vg_log"
    rm "$vg_log"
    exit 1
  fi
  rm "$vg_log"
fi
[ "$exitcode" = 255 ] || exit 1

test -n "$VERBOSE" && echo "Test passed"
exit 0
