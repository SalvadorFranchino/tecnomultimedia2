import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim minim;
AudioPlayer inicio,jugar;
AudioSample rebote;
AudioSample ruidored;

import fisica.*;

FWorld mundo;
PImage imagen_pelota, fondo, imagen_tablero, imagen_aro, imagen_personaje,portada;
ArrayList<Pelota> pelotas = new ArrayList<Pelota>(); // Lista para almacenar las pelotas
FBox tablero, personaje,rec;
FCircle aro,aroDos;
FBlob perso;
int contador = 0;
float puntoX = 833; // Cambia esto a la coordenada X del impacto de la pelota
float puntoY = 155; // Cambia esto a la coordenada Y del impacto de la pelota
int tiempo = 0;  // Inicializa el contador en 0
int ultimoSegundo = second();  // Registra el segundo actual


int ESTADO_INICIO = 0;
int ESTADO_JUEGO = 1;
int ESTADO_GANASTE = 2;
int ESTADO_PERDISTE = 3;
int estadoActual = ESTADO_INICIO; // Iniciar en el estado de inicio





void setup() {
  size(900, 540);
  Fisica.init(this);
  mundo = new FWorld();
 mundo.setEdges();
  fondo = loadImage("fondov.jpg");
  imagen_pelota = loadImage("pelota1.png");
  imagen_tablero = loadImage("Tableroposta.png");
  imagen_aro = loadImage("aroposta.png");
  imagen_personaje = loadImage("person.png");
portada = loadImage("port.jpg");

  tablero = new FBox(90, 90);
  tablero.setPosition(910, 110);
  tablero.setStatic(true);
  mundo.add(tablero);




  aro = new FCircle(60); //radio
  aro.setPosition(828, 161);
  aro.setStatic(true);
  aro.attachImage(imagen_aro);
  aro.setSensor(true); //el aro no  colisiones
  mundo.add(aro);
  
    aroDos = new FCircle(60); //radio
  aroDos.setPosition(100, 161);
 aroDos.setStatic(true);
  aroDos.attachImage(imagen_aro);
  aroDos.setSensor(true); //el aro no  colisiones
  mundo.add(aroDos);
  
  

  personaje = new FBox(120, 150);
  personaje.setPosition(width/2, height/2);
  personaje.attachImage(imagen_personaje);
  // personaje.setStatic(true);
  personaje.setRotatable(false);
  // personaje.setDensity(0);
  personaje.setName("personaje_");
  personaje.getContacts();
  mundo.add(personaje);
  minim= new Minim(this);
  inicio =minim.loadFile("musicaInicio.mp3");
  rebote =minim.loadSample("rebote.wav");
  ruidored =minim.loadSample("ruidored.mp3");
  jugar =minim.loadFile("musicaJuego.mp3");
  

rec = new FBox(900, 10);
  rec.setNoFill();
  rec.setNoStroke();
  rec.setPosition(480, 530);
  rec.setStatic(true);
  mundo.add(rec);


}

void draw() {
  //println(mouseX,mouseY);
  if (estadoActual == ESTADO_INICIO) {
    // Pantalla de inicio
    background(portada);
   // textSize(30);
    //fill(0);
    //text("¡Presione cualquier tecla para iniciar!", width/2 - 50, height/2);
    inicio.play();
    inicio.setVolume(0.5);


    if (keyPressed) {
      estadoActual = ESTADO_JUEGO;
    }
  } else if (estadoActual == ESTADO_JUEGO) {
    background(fondo);
    mundo.step();
    mundo.draw();
    inicio.pause();
        jugar.play();
   jugar.setVolume(0.5);

    // Agregar una pelota cada segundo
    if (frameCount % 30 == 0) {
      FCircle circulo = new FCircle(60);
      circulo.setPosition(random(100, 500), 0);
      circulo.attachImage(imagen_pelota);
      circulo.setVelocity(0, random(2, 5));
      circulo.setName("circulo_");
      pelotas.add(new Pelota(circulo, 5));
      mundo.add(circulo);
    }

    // Verificar si una pelota cruza las coordenadas
    for (int i = pelotas.size() - 1; i >= 0; i--) {
      Pelota pelota = pelotas.get(i);
      pelota.update();


      float distancia = dist(pelota.pelota.getX(), pelota.pelota.getY(), puntoX, puntoY);
      if (distancia < 60 / 2) {
        contador++;
        ruidored.trigger();
        pelotas.remove(i); // Eliminar la pelota
        mundo.remove(pelota.pelota);
      }

      // Verificar si la pelota ha tocado el suelo
      if (pelota.pelota.isTouchingBody(rec)) {
        pelotas.remove(i); // Eliminar la pelota
        mundo.remove(pelota.pelota);
      }
     if(tiempo>=12){
   
    pelota.pelota.setDensity(200);
    }else  if(tiempo>=18){
   
    pelota.pelota.setDensity(300);
    }
}
    // colision y sonido reboter
    // Mostrar el contador en la pantalla
    fill(255);
    textSize(30);
    text("Contador: " + contador, width/2+13, 40);

    //CONTADOR DEL TIEMPO//
    if (second() != ultimoSegundo) {
      tiempo++;  // Incrementa el contador cada vez que cambia el segundo
      ultimoSegundo = second();  // Actualiza el registro del último segundo
    }

    // Dibuja el contador en la pantalla
    fill(255);
    textSize(20);
    text("Tiempo: " + tiempo, 20, 20);
  
    
    
    if (contador>=8) {
      estadoActual =ESTADO_GANASTE;
      jugar.pause();
    } else if (tiempo>=24) {
      estadoActual = ESTADO_PERDISTE;
         jugar.pause();
    }
    // ... tu lógica de juego actual
  } else if (estadoActual == ESTADO_GANASTE) {
    // Pantalla de "ganaste"
    background(0, 255, 0);
    textSize(30);
    fill(0);
    text("¡Ganaste!", width/2 - 50, height/2);
    textSize(20);
    fill(0);
     text("¡Pulse cualquier tecla para reiniciar!", width/2-120 , height/2+50);
    if (keyPressed) {
      reiniciarJuego(); // Llama a la función para reiniciar el juego
    }
  } else if (estadoActual == ESTADO_PERDISTE) {
    // Pantalla de "perdiste"
    background(255, 0, 0);
    textSize(30);
    fill(255);
    text("¡Perdiste!", width/2 - 50, height/2);
      textSize(20);
    fill(0);
     text("¡Pulse cualquier tecla para reiniciar!", width/2-120 , height/2+50);
    if (keyPressed) {
      reiniciarJuego(); // Llama a la función para reiniciar el juego
    }
  }
}





class Pelota {
  FCircle pelota;
  float vida;

  Pelota(FCircle pelota, float tiempoDeVida) {
    this.pelota = pelota;
    this.vida = tiempoDeVida;
  }

  void update() {
    vida -= 1.0 / frameRate;
  }
}
void reiniciarJuego() {
  contador = 0;
  tiempo = 0;
  estadoActual = ESTADO_INICIO;
  // Restablecer otras variables o configuraciones necesarias
}



void contactStarted(FContact contacto) {
  FBody body1 = contacto.getBody1();
  FBody body2 = contacto.getBody2();

  if (body1.getName() != null && body2.getName() != null) {
    // Verificar si la colisión involucra al personaje y una pelota
    if ((body1.getName().equals("personaje_") && body2.getName().startsWith("circulo_")) ||
      (body2.getName().equals("personaje_") && body1.getName().startsWith("circulo_"))) {
      // La colisión involucra al personaje y una pelota
      // Puedes realizar acciones aquí, como aumentar el contador y reproducir un sonido.

      rebote.trigger(); // Reproducir el sonido de rebote cuando colisiona con el personaje
    }
  }
}
