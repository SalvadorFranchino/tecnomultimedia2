let imagenes = [];
let posicionesX = [];
let direcciones = [];
let angulos = [];
let fondo;
let rotacionActivada = false;
let gradosRotacion = 0;
let anguloObjetivo = 180;

let AMP_MIN = 0.09;
let AMP_MAX = 0.3;

let mic;
let amp;
let haySonido = false;
let MuchoSonido = false;
let PosY = 178;
let fondoPosX = 0;
let fondoPosY = 0;

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

  background(fondo);
  
  fondoPosX = map(amp, 0, AMP_MIN,0, 10); 
  fondoPosY = map(amp, 0, AMP_MIN,0, 10); 

  image(fondo, fondoPosX, fondoPosY);

  

  for (let i = 0; i < imagenes.length; i++) {
    push();
    translate(posicionesX[i], PosY);
    rotate(angulos[i]);

    imageMode(CENTER);
    image(imagenes[i], 0, 0, 80, 350);

    pop();

    if (rotacionActivada) {
      angulos[i] = radians(gradosRotacion);
    }

    if (haySonido && !MuchoSonido) {
      posicionesX[i] += 10 * direcciones[i];

      if (posicionesX[i] >= 300 || posicionesX[i] <= 100) {
        direcciones[i] *= -1;
      }
    }
  }

  amp = mic.getLevel();
  MuchoSonido = amp > AMP_MAX;

  if (MuchoSonido && !rotacionActivada) {
    rotacionActivada = true;
    if (gradosRotacion === 0) {
      anguloObjetivo = 180;
    } else {
      anguloObjetivo = 0;
    }
  }

  haySonido = amp > AMP_MIN;

  if (rotacionActivada) {
    if (gradosRotacion < anguloObjetivo) {
      gradosRotacion++;
    } else if (gradosRotacion > anguloObjetivo) {
      gradosRotacion--;
    } else {
      rotacionActivada = false;
    }
  }
}

