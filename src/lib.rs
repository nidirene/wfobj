#![allow(renamed_and_removed_lints)]
#![allow(clippy::unknown_clippy_lints)]
#![allow(clippy::upper_case_acronyms)]

use std::fs::File;
use std::io::{self, BufRead};
use std::io::{Error};
use std::path::Path;

// #[macro_use]
// extern crate log;


#[cfg(feature = "unstable-api")]
pub mod unstable;

use lrlex::{lrlex_mod};
use lrpar::{lrpar_mod};
use regex::Regex;

// Using `lrlex_mod!` brings the lexer for `calc.l` into scope. By default the module name will be
// `obj_l` (i.e. the file name, minus any extensions, with a suffix of `_l`).
lrlex_mod!("obj.l");
// Using `lrpar_mod!` brings the parser for `obj.y` into scope. By default the module name will be
// `obj_y` (i.e. the file name, minus any extensions, with a suffix of `_y`).
lrpar_mod!("obj.y");
use obj_y::Expr;

//
// 
#[derive(Debug, Default)]
pub struct World {
    pub name : String,
    pub vertices:Vec<[f32;4]>,
    pub normals:Vec<[f32;3]>,
    pub textures:Vec<[f32;3]>,
    pub faces:Vec<Vec<[u64;3]>>,
    pub mtl_lib: String,
    pub mtl: String
}

impl World {
    fn new(name: &str) -> World {
        World {
            name: name.to_string(),
            vertices : Vec::<[f32;4]>::new(),
            ..Default::default()
        }

    }

    fn add_vertex(&mut self, v: [f32;4]) {
        let vv = &mut self.vertices;
        vv.push(v);
    }

    fn add_normal(&mut self, v: [f32;3]) {
        let vv = &mut self.normals;
        vv.push(v);
    }
    
    fn add_texture(&mut self, v: [f32;3]) {
        let vv = &mut self.textures;
        vv.push(v);
    }

    fn add_face(&mut self, v: Vec<[u64;3]>) {
        let vv = &mut self.faces;
        vv.push(v);
    }

}



pub fn parse_file<P>(filename: P) -> Result<World, Error> where P: AsRef<Path>,
{
    // Get the `LexerDef` for the `calc` language.
    let lexerdef = obj_l::lexerdef();
    let file = File::open(filename)?;

    let mut w = World::new("") ;
    for line in io::BufReader::new(file).lines() {
        let l = line.as_ref().unwrap();
        if l.trim().is_empty() {
            continue;
        }
        let re = Regex::new(r"\#.*$").unwrap();
        let ll = re.replace(l," ");
        println!("> {}",ll);

        // Now we create a lexer with the `lexer` method with which we can lex each line.
        let lexer = lexerdef.lexer(&ll);
        // Pass the lexer to the parser and lex and parse the input.
        let (res, errs) = obj_y::parse(&lexer);
        for e in errs {
            print!(">>> {}\n", e.pp(&lexer, &obj_y::token_epp));
        }

        if let Some(Ok(r)) = res {
            match r {
                Expr::Vertex { coordinate: c } => w.add_vertex(c),
                Expr::NormalVertex { coordinate: c } => w.add_normal(c),
                Expr::TextureVertex { coordinate: c } => w.add_texture(c),
                // Expr::Face { indices: f } => w.faces.push(f),
                Expr::Object { name: n } => w.name = n,
                Expr::Face { indices } => w.add_face(indices),
                Expr::MtlUse { mtl: x } => w.mtl = x,
                Expr::MtlLib { filename: x } => w.mtl_lib = x,
                
                // _ => return Err(Error::new(
                //         ErrorKind::Other,
                //         "Synthax error in the file")),
            };

        } 
    }
    Ok(w) 
}


#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }

    #[test]
    fn test_parsing_box() {

        let w = parse_file("test/box.obj");

        assert_eq!(w.unwrap().vertices.len(), 8);
        
    }

}
