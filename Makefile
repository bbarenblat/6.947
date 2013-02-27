# Makefile for 6.945
# Copyright (C) 2013  Benjamin Barenblat <bbaren@mit.edu>
#
# This file is a part of 6.947.
#
# 6.947 is is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# 6.947 is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License
# along with 6.947.  If not, see <http://www.gnu.org/licenses/>.

# This Makefile is intended to build a CGI executable for use on the MIT SIPB's
# Scripts service.  Attempting to build elsewhere will require modifications.


################################ Configuration ################################

UR = urweb
URFLAGS = -protocol cgi -static

PROJECT = site
PROJECTFLAGS =


################################### Utility ###################################

# Verbosity controls
ifeq ($(V),1)
at =
ech = @true
else
ech = @echo
at = @
endif

project_structures = $(addsuffix .ur, \
	$(shell if grep --silent '^$$' $(1).urp; \
		then sed '1,/^$$/d' $(1).urp; \
		else cat $(1).urp; fi))
project_signatures = $(addsuffix .urs, \
	$(shell if grep --silent '^$$' $(1).urp; \
		then sed '1,/^$$/d' $(1).urp; \
		else cat $(1).urp; fi))
project_deps = $(call project_signatures,$(1)) $(call project_structures,$(1))


################################### Targets ###################################

all:	$(PROJECT).exe

$(PROJECT).exe: $(PROJECT).urp $(call project_deps,$(PROJECT))
	$(ech) "  URWEB $@"
	$(at)$(UR) $(URFLAGS) $(PROJECT)

clean:
	$(ech) "  RM    $(PROJECT).exe"
	$(at)$(RM) $(PROJECT).exe


serve:	$(PROJECT).exe
	$(ech) "  EXEC  $(PROJECT).exe"
	$(at)./$(PROJECT).exe $(PROJECTFLAGS)

# Normally, we'd use inotify for this, but AFS doesn't like inotify, so we get
# to use this nasty hack.
cont:	continual
continual: $(PROJECT).exe
	@while true; do \
		sums=$$(sha256sum $(PROJECT).urp $(call project_deps,$(PROJECT))); \
		$(MAKE) --no-print-directory all V=$(V); \
		newsums=$$(sha256sum $(PROJECT).urp $(call project_deps,$(PROJECT))); \
		while [ "$$sums" = "$$newsums" ]; do \
			sleep 1; \
			newsums=$$(sha256sum $(PROJECT).urp $(call project_deps,$(PROJECT))); \
		done; \
	done


.PHONY:	all clean cont continual serve
