/* readval.h
 * Routines to read a prefix or number from the current input file
 * Copyright (C) 1991-2002 Olly Betts
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

extern int root_depr_count;

prefix *read_prefix_survey(bool f_optional, bool fAllowRoot);
prefix *read_prefix_stn(bool f_optional, bool fAllowRoot);
prefix *read_prefix_stn_check_implicit(bool f_optional, bool fAllowRoot);

real read_numeric(bool f_optional, int *p_n_readings);
real read_numeric_or_omit(int *p_n_readings);

unsigned int read_uint(void);

void read_string(char **pstr, int *plen);

void read_date(void);
