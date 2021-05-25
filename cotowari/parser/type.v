module parser

import cotowari.symbols { Type }

fn (mut p Parser) parse_array_type() ?Type {
	$if trace_parser ? {
		p.trace_begin(@FN)
		defer {
			p.trace_end()
		}
	}

	p.consume_with_assert(.l_bracket)
	p.consume_with_check(.r_bracket) ?
	elem := p.parse_type() ?
	return p.scope.lookup_or_register_array_type(elem: elem).typ
}

fn (mut p Parser) parse_type() ?Type {
	$if trace_parser ? {
		p.trace_begin(@FN)
		defer {
			p.trace_end()
		}
	}

	match p.kind(0) {
		.l_bracket {
			return p.parse_array_type()
		}
		else {
			tok := p.consume_with_check(.ident) ?
			return (p.scope.lookup_type(tok.text) or { return p.error(err, tok.pos) }).typ
		}
	}
}
