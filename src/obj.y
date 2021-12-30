
%start Expr
%%

Expr -> Result<Expr, ()>:
    Virtex { $1 }
    | Face  { $1 }
    ;

Face -> Result<Expr, ()>:
    'FACE' VirtexIndices 
        {
            Ok(Expr::Face{ indices: $2? })
        }
    ;

VirtexIndices -> Result<Vec<u64>, ()>:
    Index { Ok(vec![$1?]) }
    | VirtexIndices Index { flatten($1, $2) }
    ;

Index -> Result<u64, ()>: 
    'INDEX' 
        {
          let v = $1.map_err(|_| ())?;
          parse_int($lexer.span_str(v.span()))
        }
    ;

Virtex -> Result<Expr, ()>:
    'VIRTEX' Coordinate
        {
            Ok(Expr::Virtex{ coordinate: $2? })
        }
    ;

Coordinate -> Result<[f64;4], ()>:
    Float Float Float Float { Ok([$1?, $2?, $3?, $4?]) }
    | Float Float Float 
        {
            let w: f64 = 1.0; 
            Ok([$1?, $2?, $3?, w]) 
        }
    ;

Float -> Result<f64, ()>: 
    'FLOAT' 
        {
          let v = $1.map_err(|_| ())?;
          parse_float($lexer.span_str(v.span()))
        }
    ; 

%%
// Any functions here are in scope for all the grammar actions above.
// use lrpar::Span;
#[derive(Debug)]
pub enum Expr {
    Virtex {
        coordinate: [f64;4],         
    },
    Face {
        indices: Vec<u64>,
    }
}


pub fn parse_int(s: &str) -> Result<u64, ()> {
    match s.parse::<u64>() {
        Ok(val) => Ok(val),
        Err(_) => Err(())
    }
}

pub fn parse_float(s: &str) -> Result<f64, ()> {
    match s.parse::<f64>() {
        Ok(val) => Ok(val),
        Err(_) => Err(())
    }
}

pub fn flatten<T>(lhs: Result<Vec<T>, ()>, rhs: Result<T, ()>)
           -> Result<Vec<T>, ()>
{
    let mut flt = lhs?;
    flt.push(rhs?);
    Ok(flt)
}
