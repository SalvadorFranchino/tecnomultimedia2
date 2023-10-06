import netP5.*;
import oscP5.*;



import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//oscp5
OscP5 oscP5;
NetAddress remoteLocation;

Minim minim;
AudioPlayer inicio, jugar;
AudioSample rebote;
AudioSample ruidored;

import fisica.*;

boolean caenPelotas=true;

FWorld mundo;
PImage imagen_pelota, fondo, imagen_tablero, imagen_aro, imagen_personaje, imagen_pesonajeIzq, portada, imagen_aroDos, imagen_marcador, imagen_mano, imagen_manodos;
ArrayList<Pelota> pelotas = new ArrayList<Pelota>(); // Lista para almacenar las pelotas
FBox tablero, personaje, rec, recD, tableroDos, marcador;
FCircle aro, aroDos, mano, manodos;
FBlob perso;
FDistanceJoint cadena;
int contador = 0;
float puntoX = 833; // a coordenada X del impacto de la pelota
float puntoY = 155;//  coordenada Y del impacto de la pelota
float puntoDosX = 84; // a coordenada X del impacto de la pelota
float puntoDosY = 154;
float limiteIzquierdo = 60;  //
float limiteDerecho = 400;
int tiempo = 0;  //
int ultimoSegundo = second();  // Registra el segundo actual
int tiempoUltimaAparicion = 0; // Variable para rastrear el tiempo de la última aparición
int intervaloAparicion = 1500; // Intervalo de tiempo deseado en milisegundos (1.5 segundos)
int contadorPelotas = 0; // Variable para llevar un registro de las pelotas creadas
int limitePelotas = 10;


int ESTADO_INICIO = 0;
int ESTADO_JUEGO = 1;
int ESTADO_GANASTE = 2;
int ESTADO_PERDISTE = 3;
int estadoActual = ESTADO_INICIO; // Iniciar en el estado de inicio

OscP5 myOsc;
// coordenadas {x,y} del "bounding box" de la mano
Float[] oscArribaIzquierda = {null, 100.0};
Float[] oscAbajoDerecha = {null, null};


void setup() {
  size(900, 540);
  Fisica.init(this);
  mundo = new FWorld();
  mundo.setEdges();
  fondo = loadImage("fondov.jpg");
  imagen_pelota = loadImage("pelota1.png");
  imagen_tablero = loadImage("Tableroposta.png");
  imagen_aro = loadImage("aroposta.png");
  imagen_personaje = loadImage("personsin.png");
  imagen_pesonajeIzq = loadImage("personIzq.png");
  portada = loadImage("port.jpg");
  imagen_aroDos= loadImage("aroDos.png");
  imagen_marcador= loadImage("marcador.png");
  imagen_mano= loadImage("mano.png");
  imagen_manodos= loadImage("manodos.png");


  tablero = new FBox(90, 90);
  tablero.setPosition(910, 110);
  tablero.setStatic(true);
  tablero.setFill(0, 255, 0);
  mundo.add(tablero);

  tableroDos = new FBox(65, 90);
  tableroDos.setPosition(10, 110);
  tableroDos.setStatic(true);
  mundo.add(tableroDos);

  //oscp5

  OscProperties myProperties = new OscProperties();
  myProperties.setDatagramSize(10000);
  myProperties.setListeningPort(8008); // Puerto del que recibe datos
  myOsc = new OscP5(this, myProperties);


  aro = new FCircle(60); //radio
  aro.setPosition(828, 161);
  aro.setStatic(true);
  aro.attachImage(imagen_aro);
  aro.setSensor(true); //el aro no  colisiones
  mundo.add(aro);


  aroDos = new FCircle(60); //radio
  aroDos.setPosition(80, 161);
  aroDos.setStatic(true);
  aroDos.attachImage(imagen_aroDos);
  aroDos.setSensor(true); //el aro no  colisiones
  mundo.add(aroDos);


  personaje = new FBox(120, 120);
  personaje.setPosition(width-400, 380);
  // personaje.attachImage( imagen_pesonajeIzq);
  personaje.attachImage(imagen_personaje );
  personaje.setStatic(true);
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


  rec = new FBox(900, 130);
  rec.setNoFill();
  rec.setNoStroke();
  rec.setPosition(480, 530);
  rec.setStatic(true);
  //mundo.add(rec);

  marcador = new FBox(200, 100);
  marcador.setPosition(width/2, 40);
  marcador.attachImage(imagen_marcador);
  marcador.setStatic(true);
  marcador.setSensor(true);
  mundo.add(marcador);

  mano= new FCircle(60); //radio
  mano.setPosition(mouseX, mouseY);
  //mano.setStatic(true);
  mano.attachImage( imagen_mano);
  //aroDos.setSensor(true); //el aro no  colisiones
  mano.setRotatable(false);
  mundo.add(mano);

  manodos= new FCircle(60); //radio
  manodos.setPosition(mouseX, mouseY);
  //mano.setStatic(true);
  manodos.attachImage( imagen_manodos);
  //aroDos.setSensor(true); //el aro no  colisiones
  manodos.setRotatable(false);
  mundo.add(manodos);


  cadena=new FDistanceJoint(personaje, mano);
  cadena.setAnchor1(3, 3);
  cadena.setAnchor2(1, 1);
  cadena.setStroke(157, 64, 5);
  cadena.setStrokeWeight(13);
  cadena.setLength(250);
  mundo.add(cadena);
}

void draw() {
  println(mouseX, mouseY);
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
    caenPelotas =true;

    if (oscAbajoDerecha[0] != null && oscArribaIzquierda[0] != null) {
      println("hay mano");
      float middleX = oscAbajoDerecha[0] - oscArribaIzquierda[0];
      float middleY = oscAbajoDerecha[1] - oscArribaIzquierda[1];
      personaje.setPosition(middleX, middleY);
    }

    // Agregar una pelota cada segundo
    if (caenPelotas) {

      if (contadorPelotas < limitePelotas && millis() - tiempoUltimaAparicion > intervaloAparicion) {
        FCircle circulo = new FCircle(60);
        float yPos = random(100, height - 100); // Posición vertical aleatoria dentro de ciertos límites

        // Establece la posición inicial en uno de los costados (izquierda o derecha)
        float xPos;
        float xSpeed;

        if (random(1) > 0.5) {
          // Aparece en el lado derecho y se dispara hacia la izquierda
          xPos = width;
          xSpeed = -random(50, 20); // Velocidad horizontal negativa para moverse hacia la izquierda
        } else {
          // Aparece en el lado izquierdo y se dispara hacia la derecha
          xPos = 0;
          xSpeed = random(10, 20); // Velocidad horizontal positiva para moverse hacia la derecha
        }

        circulo.setPosition(xPos, yPos);
        circulo.setVelocity(xSpeed, 0); // Velocidad vertical cero para que no caiga
        circulo.attachImage(imagen_pelota);
        circulo.setName("circulo_");
        pelotas.add(new Pelota(circulo, 5));
        //circulo.setVelocity(400, 400);
        circulo.setRestitution(0.8);
        mundo.add(circulo);

        tiempoUltimaAparicion = millis();
        contadorPelotas++;
      }
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

      float distanciaDos = dist(pelota.pelota.getX(), pelota.pelota.getY(), puntoDosX, puntoDosY);
      if (distanciaDos < 60 / 2) {
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
      if (tiempo>=12) {

        // pelota.pelota.setDensity(300);
        personaje.attachImage( imagen_pesonajeIzq);
        tablero.setFill(255);
        tableroDos.setFill(0, 255, 0);
        mano.attachImage( imagen_manodos);
      } else  if (tiempo>=18) {

        // pelota.pelota.setDensity(400);
      }
    }

    fill(0, 255, 0);
    textSize(30);
    text( contador, 504, 40);

    //CONTADOR DEL TIEMPO//
    if (second() != ultimoSegundo) {
      tiempo++;  // Incrementa el contador cada vez que cambia el segundo
      ultimoSegundo = second();  // Actualiza el registro del último segundo
    }

    // Dibuja el contador en la pantalla
    fill(255, 0, 0);
    textSize(25);
    text( "00:"+tiempo, 368, 40);


    if (contador>=8) {
      estadoActual =ESTADO_GANASTE;
      jugar.pause();
      jugar.cue(0);
      caenPelotas = ! caenPelotas;
    } else if (tiempo>=24) {
      estadoActual = ESTADO_PERDISTE;
      jugar.pause();
      jugar.cue(0);
      caenPelotas = ! caenPelotas;
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
    text("¡Pulse cualquier tecla para reiniciar!", width/2-120, height/2+50);
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
    text("¡Pulse cualquier tecla para reiniciar!", width/2-120, height/2+50);
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
  personaje.attachImage(imagen_personaje );
  caenPelotas = true;
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
