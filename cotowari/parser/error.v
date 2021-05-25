module parser

import cotowari.errors { Err }
import cotowari.source { Pos }

fn (mut p Parser) error(msg string, pos Pos) IError {
	$if trace_parser ? {
		p.trace_begin(@FN, msg, '$pos')
		defer {
			p.trace_end()
		}
	}

	err := Err{
		source: p.file.source
		msg: msg
		pos: pos
	}
	p.file.errors << err
	p.consume()
	return err
}

fn (mut p Parser) duplicated_error(name string, pos Pos) IError {
	return p.error('`$name` is duplicated', pos)
}
