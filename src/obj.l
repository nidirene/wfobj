%%
^v "VERTEX"
^f "FACE"
^vt "VTEXTURE"
^vn "VNORMAL"
^o "OBJECTNAME"
^usemtl "USEMTL"
^mtllib "MTLLIB"
[+-]?([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+) "FLOAT"
[0-9]+ "INDEX"
[a-zA-Z][a-zA-Z0-9]* "WORD"
[a-zA-Z0-9\.\-]+ "FILENAME"
(on)|(off)  "STATE"
^s          "SURFACE"
[\\/]        "FS"
[ \t\n]+ ;
