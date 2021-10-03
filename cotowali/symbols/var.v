// Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module symbols

import cotowali.source { Pos, none_pos }
import cotowali.messages { duplicated, unreachable }

pub struct Var {
mut:
	scope &Scope = 0
pub:
	name string [required]
	id   u64
	pos  Pos = none_pos()
pub mut:
	typ          Type = builtin_type(.placeholder)
	receiver_typ Type = builtin_type(.placeholder)
}

pub fn (v Var) is_member() bool {
	return v.receiver_typ != builtin_type(.placeholder)
}

pub fn (v Var) is_function() bool {
	return v.type_symbol().kind() == .function
}

pub fn (v Var) str() string {
	return 'Var{ id: $v.id, name: $v.name, scope: $v.scope_str(), typ: $v.typ }'
}

pub fn (v Var) scope() ?&Scope {
	return Symbol(v).scope()
}

fn (v Var) scope_str() string {
	return Symbol(v).scope_str()
}

pub fn (v Var) name_for_ident() string {
	return Symbol(v).name_for_ident()
}

pub fn (v Var) type_symbol() &TypeSymbol {
	if scope := v.scope() {
		return scope.lookup_type(v.typ) or { unresolved_type_symbol }
	}
	return unresolved_type_symbol
}

pub fn (v Var) receiver_type_symbol() &TypeSymbol {
	if scope := v.scope() {
		return scope.lookup_type(v.receiver_typ) or { unresolved_type_symbol }
	}
	return unresolved_type_symbol
}

// -- lookup / register --

fn (mut s Scope) check_before_register_var(v Var) ? {
	key := v.name
	if key in s.vars {
		return error(duplicated(key))
	}
}

pub fn (mut s Scope) register_var(v Var) ?&Var {
	s.check_before_register_var(v) ?
	new_v := &Var{
		...v
		id: if v.id == 0 { auto_id() } else { v.id }
		scope: s
	}
	s.vars[new_v.name] = new_v
	return new_v
}

pub fn new_placeholder_var(name string, pos Pos) &Var {
	return &Var{
		name: name
		typ: builtin_type(.placeholder)
		pos: pos
	}
}

pub fn (mut s Scope) must_register_var(v Var) &Var {
	return s.register_var(v) or { panic(unreachable(err)) }
}

pub fn (s &Scope) lookup_var(name string) ?&Var {
	if name == '_' {
		return none
	}
	if name in s.vars {
		return s.vars[name]
	}
	if p := s.parent() {
		return p.lookup_var(name)
	}
	return none
}

pub fn (s &Scope) must_lookup_var(name string) &Var {
	return s.lookup_var(name) or { panic(unreachable(err)) }
}

pub fn (s &Scope) lookup_var_with_pos(name string, pos Pos) ?&Var {
	if name in s.vars {
		v := s.vars[name]
		if v.pos.i <= pos.i || v.pos.is_none() || pos.is_none() {
			return v
		}
	}
	if p := s.parent() {
		return p.lookup_var_with_pos(name, pos)
	}
	return none
}

pub fn (s &Scope) must_lookup_var_with_pos(name string, pos Pos) &Var {
	return s.lookup_var_with_pos(name, pos) or { panic(unreachable(err)) }
}

pub fn (mut s Scope) lookup_or_register_var(v Var) &Var {
	return s.lookup_var(v.name) or { s.register_var(v) or { panic(unreachable(err)) } }
}
