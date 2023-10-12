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
AudioPlayer inicio, jugar, winer;
AudioSample rebote, trompeta, perder;
AudioSample ruidored;

import fisica.*;

boolean caenPelotas=true;
boolean queAro=true;
FWorld mundo;
PImage imagen_pelota, fondo, imagen_tablero, imagen_aro, imagen_personaje, imagen_pesonajeIzq, portada, imagen_aroDos, imagen_marcador, imagen_mano, imagen_manodos, ganaste, perdiste;
ArrayList<Pelota> pelotas = new ArrayList<Pelota>();
FBox tablero, personaje, rec, recD, tableroDos, marcador;
FCircle aro, aroDos, mano, manodos;
FBlob perso;
FDistanceJoint cadena;
int contador = 0;
float puntoX = 833;
float puntoY = 155;
float puntoDosX = 84;
float puntoDosY = 154;
float limiteIzquierdo = 60;
float limiteDerecho = 400;
int tiempo = 0;  //
int ultimoSegundo = second();
int contadorPelotas = 0;
int limitePelotas = 12;
float tiempoUltimaAparicion = 0;
int intervaloAparicion = 2000;
boolean aparicionDesdeIzquierda = true;


int ESTADO_INICIO = 0;
int ESTADO_JUEGO = 1;
int ESTADO_GANASTE = 2;
int ESTADO_PERDISTE = 3;
int estadoActual = ESTADO_INICIO;



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
  imagen_pesonajeIzq = loadImage("personIzquierda.png");
  portada = loadImage("port.jpg");
  imagen_aroDos= loadImage("aroDos.png");
  imagen_marcador= loadImage("marcador.png");
  imagen_mano= loadImage("mano.png");
  imagen_manodos= loadImage("manodos.png");
  ganaste= loadImage("ganaste.jpg");
  perdiste= loadImage("perdiste.jpg");


  tablero = new FBox(90, 90);
  tablero.setPosition(910, 110);
  tablero.setStatic(true);
  tablero.setFill(0, 255, 0);
  mundo.add(tablero);

  tableroDos = new FBox(65, 90);
  tableroDos.setPosition(10, 110);
  tableroDos.setStatic(true);
  mundo.add(tableroDos);



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
  personaje.attachImage(imagen_personaje );
  personaje.setStatic(true);
  personaje.setRotatable(false);
  personaje.setName("personaje_");
  personaje.getContacts();
  mundo.add(personaje);





  minim= new Minim(this);
  inicio =minim.loadFile("musicaInicio.mp3");
  rebote =minim.loadSample("rebote.wav");
  ruidored =minim.loadSample("ruidored.mp3");
  jugar =minim.loadFile("musicaJuego.mp3");
  perder =minim.loadSample("perder.mp3");
  winer =minim.loadFile("winer.mp3");
  trompeta =minim.loadSample("trompeta.mp3");



  marcador = new FBox(200, 100);
  marcador.setPosition(width/2, 40);
  marcador.attachImage(imagen_marcador);
  marcador.setStatic(true);
  marcador.setSensor(true);
  mundo.add(marcador);

  mano= new FCircle(60);
  mano.setPosition(mouseX, mouseY);
  mano.attachImage( imagen_mano);
  mano.setRotatable(false);
  mundo.add(mano);

  manodos= new FCircle(60); //radio
  manodos.setPosition(mouseX, mouseY);
  manodos.attachImage( imagen_manodos);
  manodos.setRotatable(false);
  mundo.add(manodos);


  cadena=new FDistanceJoint(personaje, mano);
  cadena.setAnchor1(1, 1);
  cadena.setAnchor2(2, 2);
  cadena.setStroke(157, 64, 5);
  cadena.setStrokeWeight(13);
  cadena.setLength(300);
  mundo.add(cadena);
}

void draw() {
  println(mouseX, mouseY);
  if (estadoActual == ESTADO_INICIO) {
    // Pantalla de inicio
    background(portada);
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

    // Agregar una pelota cada segundo
    if (caenPelotas) {
      if (contadorPelotas < limitePelotas && millis() - tiempoUltimaAparicion > intervaloAparicion) {
        FCircle circulo = new FCircle(60);
        float yPos = random(100, height - 200); // Posición vertical aleatoria dentro de ciertos límites

        float xPos;
        float xSpeed;

        if (aparicionDesdeIzquierda) {

          xPos = 0;
          xSpeed = random(10, 20);
        } else {
          xPos = width-50;
          xSpeed = random(10, 20);
        }

        circulo.setPosition(xPos, yPos);
        circulo.attachImage(imagen_pelota);
        circulo.setVelocity(xSpeed, random(2, 5));
        circulo.setName("circulo_");
        circulo.setRestitution(1);
        circulo.setVelocity(350, 350);
        pelotas.add(new Pelota(circulo, 5));
        mundo.add(circulo);

        contadorPelotas++;
        tiempoUltimaAparicion = millis();


        if (contadorPelotas == 6) {
          aparicionDesdeIzquierda = false;
        }
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
        pelotas.remove(i); // Eliminar  pelota
        mundo.remove(pelota.pelota);
      }

      float distanciaDos = dist(pelota.pelota.getX(), pelota.pelota.getY(), puntoDosX, puntoDosY);
      if (distanciaDos < 60 / 2) {
        contador++;
        ruidored.trigger();
        pelotas.remove(i); // Eliminar  pelota
        mundo.remove(pelota.pelota);
      }


      if (queAro==true && distanciaDos<60/2) {
        contador--;
      } else if (queAro==false && distancia <60/2) {

        contador--;
      }


      if (tiempo>=12) {
        personaje.attachImage( imagen_pesonajeIzq);
        tablero.setFill(255);
        tableroDos.setFill(0, 255, 0);
        queAro=false;
        mano.attachImage( imagen_manodos);
      }

      if (tiempo == 23) {
        // Elimina todas  pelotas 

        pelotas.remove(i);
        mundo.remove(pelota.pelota);
        perder.trigger();
        trompeta.trigger();
      }
    }

    fill(0, 255, 0);
    textSize(30);
    text( contador, 504, 40);

    //CONTADOR DEL TIEMPO//
    if (second() != ultimoSegundo) {
      tiempo++;  
      ultimoSegundo = second();  
    }

    // Dibuja el contador en  pantalla
    fill(255, 0, 0);
    textSize(25);
    text( "00:"+tiempo, 368, 40);


    if (contador>=3) {
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

  } else if (estadoActual == ESTADO_GANASTE) {
    // Pantalla de "ganaste"
    background(ganaste);
    winer.play();
    if (keyPressed) {
      reiniciarJuego(); 
    }
  } else if (estadoActual == ESTADO_PERDISTE) {
    // Pantalla de perdiste
    background(perdiste);
  
    if (keyPressed) {
      reiniciarJuego(); 
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
  mano.attachImage( imagen_mano);
  tablero.setFill(0, 255, 0);
  tableroDos.setFill( 255);
  caenPelotas = true;
  contadorPelotas =0;
  tiempoUltimaAparicion = 0;
  aparicionDesdeIzquierda = true;
  winer.pause();
  winer.cue(0);
  queAro=true;
}



void contactStarted(FContact contacto) {
  FBody body1 = contacto.getBody1();
  FBody body2 = contacto.getBody2();

  if (body1.getName() != null && body2.getName() != null) {
    // Verificar si la colisión involucra al personaje y una pelota
    if ((body1.getName().equals("personaje_") && body2.getName().startsWith("circulo_")) ||
      (body2.getName().equals("personaje_") && body1.getName().startsWith("circulo_"))) {
    

      rebote.trigger(); 
    }
  }
}
