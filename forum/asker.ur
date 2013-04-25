type asker = option string

val eq_asker = Option.eq

val show_asker =
    mkShow (
        fn nameOpt =>
	    case nameOpt of
        	None => "Anonymous"
              | Some nam => nam
    )

val read_asker =
    let fun parse text =
	    case text of
		"Anonymous" => None
	      | nam => Some nam
    in
	mkRead parse (compose Some parse)
    end

val sql_asker = sql_option_prim

val anonymous = None

val namedAsker = Some
