module ast

import vash.pos { Pos }
import vash.token { Token }

pub struct File {
pub:
	path string
pub mut:
	stmts  []Stmt
	errors []ErrorNode
}

pub type Stmt = EmptyStmt | FnDecl | Expr

pub struct EmptyStmt {}

pub struct Var {
pub:
	pos Pos
	name			string
}

pub struct FnDecl {
pub:
	pos  Pos
	name string
pub mut:
	params []Var
	stmts []Stmt
}

pub struct InfixExpr {
pub:
	pos   Pos
	op    Token
	left  Expr
	right Expr
}

// expr | expr | expr
pub struct Pipeline {
pub:
	pos   Pos
	exprs []Expr
}

pub type Expr = CallFn | InfixExpr | IntLiteral | Pipeline

pub struct CallFn {
pub:
	pos  Pos
	name string
	args []Expr
}

pub struct IntLiteral {
pub:
	pos   Pos
	token Token
}

pub struct ErrorNode {
pub:
	pos Pos
	// Implements IError
	msg  string
	code int
}
