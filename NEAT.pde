import java.util.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.lang.Object.*;

/*
  TODO :
 Créer une nouvelle structure, layer contenant une arrayList des nodes d'un même niveau //Plutot dur à mettre en place
 Faire un crossover des nodes, on peut prendre seulement une partie de l'arbre de la première, et une partie de la deuxième. Network crossover(Network n1, Network n2);
 Créer une fonction permettant de passer d'une liste de nodes à une arrayList de layers //Juste modifier la fonction actuelle
 */

/* Réseau de base 
 nn.addConnexion(0, 1);
 nn.addConnexion(0, 2);
 nn.addNode(0, 1);
 nn.addNode(0, 2);
 nn.addConnexion(3, 2);
 nn.show(0, 0, width, height);
 */

//On essaie de résoudre le problème XOR sans crossover entre les nodes, les meilleurs seront simplement dupliquées

float[][] inputs = new float[][]{{0, 0}, {0, 1}, {1, 0}, {1, 1}};
 float[] outputs = new float[]{0, 1, 1, 0};
 int innovation, nbSelected = 50;
 
 Network[] nns = new Network[100];

void setup() {
  size(1000, 1000);
  colorMode(HSB, 255);
  Network nn = new Network(2, 1);
  nn.addConnexion(0, 2);
  nn.addConnexion(1, 2);
  nn.addNode(0, 2);
  
  nn.show(0, 0, width, height);
  println(nn.feedForward(inputs[0])[0]+nn.feedForward(inputs[1])[0]+nn.feedForward(inputs[2])[0]+nn.feedForward(inputs[3])[0]);
  /*for (int i=0; i<nns.length; i++) {
   nns[i] = new Network(2, 1);
   nns[i].addConnexion(0, 2);
   nns[i].addConnexion(1, 2);
   }*/
}

void draw() {

  /*for (int ind  = 0; ind<100; ind++) {
   //Calcul du score des différents réseaux
   float[] scores = new float[nns.length]; //Stocke les différents scores des réseaux de neurones
   for (int i=0; i<nns.length; i++) {
   for (int j=0; j<4; j++) {
   scores[i] += abs(abs(nns[i].feedForward(inputs[j])[0]) - abs(outputs[j])); //On ajoute au score de chaque réseau le carré de la différence entre le résultat rendu et voulu
   }
   //scores[i] = abs(scores[i]);
   }
   
   //Tri des réseaux suivant le score
   nns = sortNN(nns, scores);
   //Sélection des 40 meilleurs
   //Duplication des 40 meilleurs sur les indices [39] à [80]
   for (int i=0; i<nbSelected; i++) {
   nns[i+nbSelected] = nns[i];
   }
   
   //Mutation des 80 premiers éléments
   for (int i=0; i<2*nbSelected; i++) {
   nns[i].mutate(0.01);
   }
   
   //Création de nouveaux éléments sur la fin de l'array, et les muter 5 fois
   for (int i=2*nbSelected; i<nns.length; i++) {
   nns[i] = new Network(2, 1);
   for (int j=0; j<5; j++) {
   nns[i].mutate(1);
   }
   }
   }
   println(nns[0].feedForward(inputs[0])[0], nns[0].feedForward(inputs[1])[0], nns[0].feedForward(inputs[2])[0], nns[0].feedForward(inputs[3])[0]);
   */
}


Network[] sortNN(Network[] nn, float[] scores) {
  int i=1, j;
  Network temp;
  float tempS;

  while (i<nn.length) {
    j=i;
    while (j>0 && scores[j-1] > scores[j]) {
      tempS = scores[j-1];
      scores[j-1] = scores[j];
      scores[j] = tempS;
      temp = nn[j-1];
      nn[j-1] = nn[j];
      nn[j] = temp;
      j--;
    }
    i++;
  }
  return nn;
}

void keyPressed() {
  /*if (key == ' ') {
    background(255);
    nns[0].show(500, 500, width, height);
    printArray(nns[0].feedForward(inputs[1]));
    for (int i=0; i<100; i++) {
      for (int j=0; j<100; j++) {
        float[] inp = new float[]{i/100.0, j/100.0};
        float val = nns[0].feedForward(inp)[0];
        fill(val*255);
        noStroke();
        rect(i*2, j*2, 2, 2);
      }
    }
  }*/
}
