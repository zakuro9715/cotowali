module sh

import cotowari.ast
import cotowari.util { must_write }

pub fn (mut e Emitter) emit(f &ast.File) {
	e.file(f)
	must_write(e.out, e.code.bytes())
}

fn (mut emit Emitter) file(f &ast.File) {
	emit.cur_file = f
	emit.builtin()
	emit.code.writeln('# file: $f.source.path')
	emit.stmts(f.stmts)
}

fn (mut emit Emitter) builtin() {
	builtins := [
		$embed_file('../../../builtin/builtin.sh'),
		$embed_file('../../../builtin/array.sh'),
	]
	for f in builtins {
		emit.code.writeln(f.to_string())
	}
}
