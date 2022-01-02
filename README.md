# 

[format of the ](http://paulbourke.net/dataformats/obj/)
Rust library load locad blender obj file to Rust NDArray.

```
cargo run test\t10k-images.idx3-ubyte
```
A png file will be generated for the first image in the file.

## Object files (.obj)

Object files define the geometry and other properties for objects in
Wavefront's Advanced Visualizer. Object files can also be used to
transfer geometric data back and forth between the Advanced Visualizer
and other applications.

## File structure

The following types of data may be included in an .obj file. In this
list, the keyword (in parentheses) follows the data type.

__Vertex data__

- geometric vertices (`v`)
- texture vertices (`vt`)
- vertex normals (`vn`)
- parameter space vertices (`vp`)

Free-form curve/surface attributes
- rational or non-rational forms of curve or surface type: basis matrix, Bezier, B-spline, Cardinal, Taylor (cstype)
- degree (`deg`)
- basis matrix (`bmat`)
- step size (`step`)

### Elements

- point (`p`)
- line (`l`)
- face (`f`)
- curve (`curv`)
- 2D curve (`curv2`)
- surface (`surf`)

Free-form curve/surface body statements

- parameter values (`parm`)
- outer trimming loop (`trim`)
- inner trimming loop (`hole`)
- special curve (`scrv`)
- special point (`sp`)
- end statement (`end`)

### Connectivity between free-form surfaces

- connect (`con`)

### Grouping

- group name (`g`)
- smoothing group (`s`)
- merging group (`mg`)
- object name (`o`)

### Display/render attributes

- bevel interpolation (`bevel`)
- color interpolation (`c_interp`)
- dissolve interpolation (`d_interp`)
- level of detail (`lod`)
- material name (`usemtl`)
- material library (`mtllib`)
- shadow casting (`shadow_obj`)
- ray tracing (`trace_obj`)
- curve approximation technique (`ctech`)
- surface approximation technique (`stech`)