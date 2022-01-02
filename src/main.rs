#![allow(clippy::unnecessary_wraps)]
use wfobj::*;

fn main() {
    match parse_file("./test/box.obj") {
        Ok(x) => println!("nomber of vertices is {:?}", x.vertices.len()),
        Err(e) => println!("{}", e),
    }
}