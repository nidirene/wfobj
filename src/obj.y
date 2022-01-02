
%start Expr
%%

Expr -> Result<Expr, ()>:
    Vertex { $1 }
    | NormalVertex { $1 }
    | TextureVertex { $1 }
    | Face  { $1 }
    | Object { $1 }
    | UseMTL { $1 }
    | MTLLib { $1 }
    ;

// Object Name
Object -> Result<Expr, ()>:
    'OBJECTNAME' Word 
        {
            Ok(Expr::Object{ name: $2? })
        }
    | 'OBJECTNAME' Index
        {
            Ok(Expr::Object{ name: $2?.to_string()})
        }
    ;


// 
// Face
// 
Face -> Result<Expr, ()>:
    'FACE' VIndices 
        {
            Ok(Expr::Face{ indices: $2? })
        }
    ;

VIndices -> Result<Vec<[u64; 3]>, ()>:
    FIndex  { Ok(vec![$1?]) }
    | VIndices FIndex { flatten($1, $2) }
    ;

FIndex -> Result<[u64; 3], ()>:
    Index  { Ok([$1?, 0, 0]) } 
    | Index 'FS' 'FS' Index { Ok([$1?,0,$4?]) }
    | Index 'FS' Index 'FS' Index { Ok([$1?,$3?,$5?]) }
    ;

Index -> Result<u64, ()>: 
    'INDEX'
        {
          let v = $1.map_err(|_| ())?;
          parse_int($lexer.span_str(v.span()))
        }
    ;

// 
//  Vertex
// 
Vertex -> Result<Expr, ()>:
    'VERTEX' Coordinate
        {
            Ok(Expr::Vertex{ coordinate: $2? })
        }
    ;

NormalVertex -> Result<Expr, ()>:
    'VNORMAL' NormalCoordinate
        {
            Ok(Expr::NormalVertex{ coordinate: $2? })
        }
    ;

TextureVertex -> Result<Expr, ()>:
    'VTEXTURE' TextureCoordinate
        {
            Ok(Expr::TextureVertex{ coordinate: $2? })
        }
    ;

Coordinate -> Result<[f32;4], ()>:
    Float Float Float Float { Ok([$1?, $2?, $3?, $4?]) }
    | Float Float Float 
        {
            let w: f32 = 1.0; 
            Ok([$1?, $2?, $3?, w]) 
        }
    ;

NormalCoordinate -> Result<[f32;3], ()>:
    Float Float Float 
        {
            Ok([$1?, $2?, $3?]) 
        }
    ;

TextureCoordinate -> Result<[f32;3], ()>:
    Float Float Float 
        {
            Ok([$1?, $2?, $3?]) 
        }
    | Float Float 
        {
            Ok([$1?, $2?, 0.0]) 
        }
    | Float 
        {
            Ok([$1?, 0.0, 0.0]) 
        }
    ;



UseMTL -> Result<Expr, ()>:
    'USEMTL' Word
        {
            Ok(Expr::MtlUse{ mtl: $2?.to_string()})
        }
    ;


MTLLib -> Result<Expr, ()>:
    'MTLLIB' FileName 
        {
            Ok(Expr::MtlLib{ filename: $2?.to_string()})
        }
    ;

Word -> Result<String, ()>:
    'WORD'
        { 
            let v = $1.map_err(|_| ())?;
            Ok($lexer.span_str(v.span()).to_string()) 
        }
    ;
// Comment -> Result<String,()>:
//     'COMMENT' 
//     { 
//         Ok("".to_string()) 
//     }
//     ;

FileName -> Result<String, ()>:
    'FILENAME'
        { 
            let v = $1.map_err(|_| ())?;
            Ok($lexer.span_str(v.span()).to_string()) 
        }
    ;

Float -> Result<f32, ()>: 
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
pub enum Expr{
    Vertex {
        coordinate: [f32;4],         
    },
    NormalVertex {
        coordinate: [f32;3],         
    },
    TextureVertex {
        coordinate: [f32;3],
    },
    Face {
        indices: Vec<[u64;3]>,
    },
    Object {
        name: String,
    },
    MtlUse {
        mtl: String,
    },
    MtlLib {
        filename: String,
    }
}


pub fn parse_int(s: &str) -> Result<u64, ()> {
    match s.parse::<u64>() {
        Ok(val) => Ok(val),
        Err(_) => Err(())
    }
}

pub fn parse_float(s: &str) -> Result<f32, ()> {
    match s.parse::<f32>() {
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
