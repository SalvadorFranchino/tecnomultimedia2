function setup() {
  createCanvas(400, 400);

}
//eje 200, 200, para izquierda dibuja negro, para derecha dibuja otros colores preseteados
function draw() {
 background(255);
  //fill (0)
//obra
  if (mouseX < width / 2) { // Si el mouse está a la izquierda del canvas
    fill(0); // Establece el color de relleno en negro
    rect(mouseX, mouseY, 50, 80); // Dibuja un rectángulo desde el borde izquierdo hasta la posición del mouse en el eje x
  }
}