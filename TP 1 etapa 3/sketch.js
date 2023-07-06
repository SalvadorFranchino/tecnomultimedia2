let imagenes = [];
let indiceImagen = 0;
let fondo;

function preload() {
  fondo = loadImage('Fotos/fondo Tecno.jpg');
  imagenes[0] = loadImage('Fotos/rect negro.png');
  imagenes[1] = loadImage('Fotos/rect negro cortado.png');
  imagenes[2] = loadImage('Fotos/rect naranja.png');
  imagenes[3] = loadImage('Fotos/rect marron.png');
  imagenes[4] = loadImage('Fotos/rect marron cortado.png');
  imagenes[5] = loadImage('Fotos/rect arena.png');
  imagenes[6] = loadImage('Fotos/rec cortado naranja.png');
  imagenes[7] = loadImage('Fotos/rect negro silueta.png');
    
}

function setup() {
  createCanvas(400, 400);
  background(fondo);




}

function draw() {}

function mouseClicked() {

  
  let rangoXInicio = 100;  //  x del inicio del rango
  let rangoXFin = 300;    //  x del fin del rango
  let rangoYInicio = 50;  //  y del inicio del rango
  let rangoYFin = 350;    // y del fin del rango

  // condicion de los parametros en los que se dibuja
  
  if (mouseX > rangoXInicio && mouseX < rangoXFin && mouseY > rangoYInicio && mouseY < rangoYFin) {
   
    // Dibujar la imagen centrada en el cursor
    
    imageMode(CENTER);
    image(imagenes[indiceImagen], mouseX, mouseY,450,350);
 
 
  
  }
}


function keyPressed() {
  if (key === ' ') {
    // Cambiar a otra  imagen
    indiceImagen = (indiceImagen + 1) % imagenes.length;
  }
}
