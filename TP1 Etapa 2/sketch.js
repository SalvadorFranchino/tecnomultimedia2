function preload() {
  fondo = loadImage('fotos/fondo_Tecno.jpg');
}
function setup() {
image(fondo,400,400)
  createCanvas(400,400);
  background(fondo);
}
//eje 200, 200, para izquierda dibuja negro, para derecha dibuja otros colores preseteados
function draw() {
  //fill (0)
//obra
  
  if (mouseX < width / 2) {
    fill(0); // Establece el color de relleno en negro
    rect(random(50,300),random(50,100), random(20, 30), random(150,300))
  }
  else {
    fill(random(255), random(255), random(255)); // Establece el color de relleno en negro
    rect(random(50,300),random(50,100), random(20, 30), random(150,300))
  }
}