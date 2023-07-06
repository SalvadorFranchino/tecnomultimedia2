let imagenes = [];
let posicionesX = [];
let direcciones = [];
let angulos = [];
let fondo;
let rotacionActivada = false;

let AMP_MIN = 0.01;
let AMP_MAX = 0.1;

let mic;
let amp;
let haySonido = false;
let MuchoSonido = false;
let imprimir = true;

let rotacionRealizada = false; // Variable para controlar si la rotación ya se realizó

function preload() {
  fondo = loadImage('Fotos/fondo Tecno.jpg');
  imagenes[0] = loadImage('Fotos/obj1.j.png');
  imagenes[1] = loadImage('Fotos/obj2.png');
  imagenes[2] = loadImage('Fotos/obj3.png');
  imagenes[3] = loadImage('Fotos/obj4.png');
}

function setup() {
  createCanvas(400, 400);
  
  fondo.resize(width, height);

  mic = new p5.AudioIn();
  mic.start();
  userStartAudio();

  posicionesX[0] = 130;
  posicionesX[1] = 180;
  posicionesX[2] = 230;
  posicionesX[3] = 280;

  direcciones[0] = 1;
  direcciones[1] = 1;
  direcciones[2] = -1;
  direcciones[3] = -1;

  angulos[0] = 0;
  angulos[1] = 0;
  angulos[2] = 0;
  angulos[3] = 0;
}

function draw() {
  image(fondo, 0, 0);

  if (imprimir) {
    printData(); 
  }

  for (let i = 0; i < imagenes.length; i++) {
    push();
    translate(posicionesX[i], height / 2);
    rotate(angulos[i]);
    
    imageMode(CENTER);
    image(imagenes[i], 0, 0, 80, 350);
    
    pop();
    
    if (rotacionActivada && !rotacionRealizada) {
      angulos[i] += 0.01;
      
    }  
  }
  
  amp = mic.getLevel();
  MuchoSonido = amp > AMP_MAX;
  
  if (MuchoSonido && !rotacionRealizada) {
    rotacionActivada = true;
  } else {
    rotacionActivada = false;
    rotacionRealizada = false;
  }
  
  haySonido = !MuchoSonido && amp > AMP_MIN;

  if (haySonido) {
    posicionesX[0] += 10 * direcciones[0];
    posicionesX[1] += 20 * direcciones[1];
    posicionesX[2] -= 10 * direcciones[2];
    posicionesX[3] -= 20 * direcciones[3];
    
    if (posicionesX[0] >= 300 || posicionesX[0] <= 100) {
      direcciones[0] *= -1;
    }
    if (posicionesX[1] >= 300 || posicionesX[1] <= 100) {
      direcciones[1] *= -1;
    }
    if (posicionesX[2] >= 300 || posicionesX[2] <= 100) {
      direcciones[2] *= -1;
    }
    if (posicionesX[3] >= 300 || posicionesX[3] <= 100) {
      direcciones[3] *= -1;
    }
  }
}

function printData() {
 // push();
 // textSize(16);
//  fill(0);
 // let texto = 'Amplitud: ' + amp;
 // text(texto, 20, 20);
 // pop();
} 
