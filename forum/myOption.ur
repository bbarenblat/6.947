fun getError [t] maybe =
    case maybe of
	None => error <xml>Attempted to extract a value out of a None</xml>
      | Some v => v
