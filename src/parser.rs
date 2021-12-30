pub obj_parser() {
    match stdin.lock().lines().next() {
        Some(Ok(ref l)) => {
            if l.trim().is_empty() {
                continue;
            }
            let lexer = lex(l);
            // Pass the lexer to the parser and lex and parse the input.
            let (res, errs) = calc_y::parse(&lexer);
            for e in errs {
                println!("{}", e.pp(&lexer, &calc_y::token_epp));
            }
            if let Some(Ok(r)) = res {
                match eval(&lexer, r) {
                    Ok(i) => println!("Result: {}", i),
                    Err((span, msg)) => {
                        let ((line, col), _) = lexer.line_col(span);
                        eprintln!(
                            "Evaluation error at line {} column {}, '{}' {}.",
                            line,
                            col,
                            lexer.span_str(span),
                            msg
                        )
                    }
                }
            }
        }
        _ => break,
    }
}