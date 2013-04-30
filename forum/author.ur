type author = option string

val eq_author = Option.eq

val show_author =
    mkShow (
        fn nameOpt =>
	    case nameOpt of
        	None => "Anonymous"
              | Some nam => nam
    )

val read_author =
    let fun parse text =
	    case text of
		"Anonymous" => None
	      | nam => Some nam
    in
	mkRead parse (compose Some parse)
    end

val sql_author = sql_option_prim

val anonymous = None

val namedAuthor = Some
