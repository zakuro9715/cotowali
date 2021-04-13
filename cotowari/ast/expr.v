module ast

import cotowari.source { Pos }
import cotowari.token { Token }
import cotowari.symbols

pub type Expr = CallFn | InfixExpr | IntLiteral | Pipeline | StringLiteral | Var

pub fn (expr Expr) pos() Pos {
	return match expr {
		CallFn, Var { expr.pos }
		InfixExpr { expr.left.pos().merge(expr.right.pos()) }
		Pipeline { expr.exprs.first().pos().merge(expr.exprs.last().pos()) }
		IntLiteral, StringLiteral { expr.token.pos }
	}
}

pub fn (e Expr) typ() &symbols.Type {
	return match e {
		IntLiteral { &symbols.int_type }
		StringLiteral { &symbols.string_type }
		Pipeline { e.exprs.last().typ() /* TODO */ }
		InfixExpr { e.right.typ() /* TODO */ }
		CallFn { Expr(e.func).typ() /* TODO */ }
		Var { e.sym.typ }
	}
}

pub struct InfixExpr {
pub:
	op    Token
	left  Expr
	right Expr
}

// expr | expr | expr
pub struct Pipeline {
pub:
	exprs []Expr
}

pub struct Var {
pub:
	pos Pos
	sym symbols.Var
}

pub struct CallFn {
pub:
	pos Pos
pub mut:
	func Var
	args []Expr
}

pub struct IntLiteral {
pub:
	token Token
}

pub struct StringLiteral {
pub:
	token Token
}
