// Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module source

import os

const std_file = $embed_file('../../builtin/std.li')

pub const std = new_source('std.ri', std_file.to_string())

[heap]
pub struct Source {
mut:
	lines []string
pub:
	path string
	code string
}

pub fn new_source(path string, code string) &Source {
	return &Source{
		path: path
		code: code
	}
}

// at returns one Char at code[i]
pub fn (s &Source) at(i int) Char {
	end := i + utf8_char_len(s.code[i])
	return Char(s.code[i..end])
}

pub fn (s &Source) slice(begin int, end int) string {
	return s.code.substr(begin, end)
}

fn (mut s Source) set_lines() {
	s.lines = s.code.split_into_lines()
}

pub fn (s &Source) line(i int) string {
	if s.lines.len == 0 {
		unsafe {
			s.set_lines()
		}
	}
	return if i <= s.lines.len { s.lines[i - 1] } else { '' }
}

pub fn (s &Source) file_name() string {
	return os.file_name(s.path)
}

pub fn read_file(path string) ?&Source {
	code := os.read_file(path) ?
	return new_source(path, code)
}
