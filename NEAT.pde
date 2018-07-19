import java.util.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.lang.Object.*;

/*
  TODO :
 Créer une nouvelle structure, layer contenant une arrayList des nodes d'un même niveau //Plutot dur à mettre en place
 Faire un crossover des nodes, on peut prendre seulement une partie de l'arbre de la première, et une partie de la deuxième. Network crossover(Network n1, Network n2);
 Créer une fonction permettant de passer d'une liste de nodes à une arrayList de layers //Juste modifier la fonction actuelle
 */


int innovation;
Network nn = new Network(1, 2);
float[] inputs = new float[]{1, 1, 1, 1, 1};

void setup() {
  size(1000, 1000);
  colorMode(HSB,255);
  randomSeed(17461);
  /* nn.addConnexion(0, 1);
   nn.addConnexion(0, 2);
   nn.addNode(0, 1);
   nn.addNode(0, 2);
   nn.addConnexion(3, 2);
   nn.showNN(0, 0, width, height);*/
  //frameRate(10);
  for (int i=0; i<91; i++) {
    nn.mutate(1);
    nn.calculateLayers();
    background(195);
    nn.showNN(0, 0, width, height);
  }
  nn.mutate(1);
  nn.printConnexions();
  nn.calculateLayers();
  background(195);
  nn.showNN(0, 0, width, height);
  for (int i=0; i<10; i++) {
    nn = new Network(floor(random(1, 50)), floor(random(1, 50)));
    for (int j=0; j<100; j++) {
      nn.mutate(1);
      nn.calculateLayers();
      //nn.cleanConnexions();
      //nn.calculateLayers();
      //nn.showNN(0, 0, width, height);
    }
    println(i);
  }
  background(204);
  nn.showNN(0, 0, width, height);


  println("terminé");
}

void draw() {
}
