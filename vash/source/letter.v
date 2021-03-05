module source

import vash.util { @in }

pub type Letter = string // utf-8 char

pub fn (c Letter) rune() rune {
	return rune(c.utf32_code())
}

pub enum LetterClass {
	whitespace
	alphabet
}

pub fn (c Letter) @is(class LetterClass) bool {
	return match class {
		.whitespace { (c.len == 1 && c[0].is_space() && c[0] !in [`\n`, `\r`]) || c == '　' }
		.alphabet { @in(c[0], `a`, `z`) || @in(c[0], `A`, `Z`) }
	}
}
