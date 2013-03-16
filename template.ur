(* Template -- site templates
Copyright (C) 2013  Benjamin Barenblat <bbaren@mit.edu>

This file is a part of 6.947.

6.947 is is free software: you can redistribute it and/or modify it under the
terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

6.947 is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with 6.947.  If not, see <http://www.gnu.org/licenses/>. *)

open Styles

fun pageTitleTag nameOpt =
    let val titleString =
	    case nameOpt of
		| None => "6.947 – Functional Programming Project Laboratory"
		| Some s => "6.947 – " ^ s
    in
	<xml>
	  <title>{[titleString]}</title>
	</xml>
    end

fun generic (pageName : option string) (content : xbody) : xhtml [] [] =
    <xml>
      <head>
	{pageTitleTag pageName}
	<link rel="stylesheet" type="text/css" href="//bbaren.scripts.mit.edu/urweb/6.947-static/site.css"/>
      </head>
      <body>
	{content}
	<div class={footer}>
	  <p>
	    6.947 is free software: you can redistribute it and/or modify it under the terms of the <a href="//gnu.org/licenses/agpl"><span class={smallCaps}>gnu</span> Affero General Public License</a> as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
	  </p>

	  <p>
	    6.947 is distributed in the hope that it will be useful, but <span class={smallCaps}>without any warranty</span>; without even the implied warranty of <span class={smallCaps}>merchantability</span> or <span class={smallCaps}>fitness for a particular purpose</span>.
	    See the <span class={smallCaps}>gnu</span> Affero General Public License for more details.
	  </p>

	  <p>
	    You can get the 6.947 source code <a href="file:///afs/athena.mit.edu/user/b/b/bbaren/web_scripts/urweb/6.947/">via AFS</a>.
	  </p>
	</div>
      </body>
    </xml>
