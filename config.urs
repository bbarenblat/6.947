(* Config -- site-wide configuration
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

(* The base URL for the site *)
val baseUrlS : string

(* The name of the site *)
val siteTitle : xbody

(* The menu scheme in this app is based on a variant 'pageName', which
describes the name of the page.  There's one value for each page. *)
con pageName = variant (mapU unit [Main, Forum])
