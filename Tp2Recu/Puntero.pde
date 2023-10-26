class Puntero {

  float id;
  float x;
  float y;
  float diametro;
  PImage Imagen_personaje;
    PImage Imagen_personajeIzq;

  FWorld mundo; // puntero al mundo de fisica que está en el main


  FCircle body;

  FMouseJoint mj;

  Puntero(FWorld _mundo, float _id, float _x, float _y) {
    mundo = _mundo;
    id = _id;
    x = _x;
    y = _y;
    diametro = 120;

    body = new FCircle(diametro);
    body.setNoStroke();
   body.setNoFill();
    body.setPosition(width-400, 380);
     body.setRotatable(false);
     body.getContacts();
    mj = new FMouseJoint(body, x, y);

    mundo.add(body);
    mundo.add(mj);
    Imagen_personaje=loadImage("person.png");
    Imagen_personajeIzq=loadImage("personIzq.png");
  }

  void setTarget(float nx, float ny) {
    mj.setTarget(nx, ny);
  }

  void setID(float id) {
    this.id = id;
  }

  void borrar() {
    mundo.remove(mj);
    mundo.remove(body);
  }
  
  void dibujar() {

    body.attachImage(Imagen_personaje);    
     if(tiempo>=12){
      body.attachImage(Imagen_personajeIzq); 
     }
  }
}
