// Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module checker

import cotowali.ast
import cotowali.context { Context }

pub fn check(mut f ast.File, ctx &Context) {
	mut c := new_checker(ctx)
	c.check(mut f)
}

pub fn (mut c Checker) check(mut f ast.File) {
	c.check_file(mut f)
}

fn (mut c Checker) check_file(mut f ast.File) {
	$if trace_checker ? {
		c.trace_begin(@FN)
		defer {
			c.trace_end()
		}
	}

	old_source := c.source
	defer {
		c.source = old_source
	}
	c.source = f.source
	c.stmts(f.stmts)
}
