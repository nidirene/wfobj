#![allow(clippy::unnecessary_wraps)]

use std::io::{self, BufRead, Write};

use lrlex::{lrlex_mod};
use lrpar::{lrpar_mod};

// Using `lrlex_mod!` brings the lexer for `calc.l` into scope. By default the module name will be
// `obj_l` (i.e. the file name, minus any extensions, with a suffix of `_l`).
lrlex_mod!("obj.l");
// Using `lrpar_mod!` brings the parser for `obj.y` into scope. By default the module name will be
// `obj_y` (i.e. the file name, minus any extensions, with a suffix of `_y`).
lrpar_mod!("obj.y");
use obj_y::Expr;

fn main() {
    // Get the `LexerDef` for the `calc` language.
    let lexerdef = obj_l::lexerdef();
    let stdin = io::stdin();
    loop {
        print!(">>> ");
        io::stdout().flush().ok();
        match stdin.lock().lines().next() {
            Some(Ok(ref l)) => {
                if l.trim().is_empty() {
                    continue;
                }
                // Now we create a lexer with the `lexer` method with which we can lex an input.
                let lexer = lexerdef.lexer(l);
                // Pass the lexer to the parser and lex and parse the input.
                let (res, errs) = obj_y::parse(&lexer);
                for e in errs {
                    println!("{}", e.pp(&lexer, &obj_y::token_epp));
                }
                if let Some(Ok(r)) = res {
                    match eval(r) {
                        Ok(i) => println!("Result: {}", i),
                        Err(_) => println!("Error"),
                    }
                }
            }
            _ => break,
        }
    }
}

fn eval(e: Expr)  -> Result<String, ()>  {
    match e {
        Expr::Virtex { coordinate: c } => Ok(format!("Virtex with {} {} {} {}", c[0], c[1], c[2], c[3])),
        Expr::Face { indices: _ } => Ok(format!("Face")),
    }
}