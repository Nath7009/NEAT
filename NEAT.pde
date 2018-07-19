import java.util.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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
 nn.showNN(0, 0, width, height);
 */

//On essaie de résoudre le problème XOR sans crossover entre les nodes, les meilleurs seront simplement dupliquées

float[][] inputs = new float[][]{{0, 0}, {0, 1}, {1, 0}, {1, 1}};
float[] outputs = new float[]{0, 1, 1, 0};
int innovation, nbSelected = 400;

Network[] nns = new Network[1000];

void setup() {
  size(1000, 1000);
  colorMode(HSB, 255);

  for (int i=0; i<nns.length; i++) {
    nns[i] = new Network(2, 1);
    for (int j=0; j<5; j++) {
      nns[i].mutate(1);
    }
  }
}

void draw() {

  for (int ind  = 0; ind<100; ind++) { //<>//
    //Calcul du score des différents réseaux
    float[] scores = new float[nns.length]; //Stocke les différents scores des réseaux de neurones
    for (int i=0; i<nns.length; i++) {
      for (int j=0; j<outputs.length; j++) {
        scores[i] += sq(sq(nns[i].feedForward(inputs[j])[0]) - outputs[j]); //On ajoute au score de chaque réseau le carré de la différence entre le résultat rendu et voulu
      }
    }

    //Tri des réseaux suivant le score
    nns = sortNN(nns, scores);
    println(scores[0]);
    //Sélection des 40 meilleurs
    //Duplication des 40 meilleurs sur les indices [39] à [80]
    for (int i=0; i<nbSelected; i++) {
      nns[i+nbSelected] = nns[i];
    }

    //Mutation des 80 premiers éléments
    for (int i=0; i<2*nbSelected; i++) {
      nns[i].mutate(0.1);
    }

    //Création de nouveaux éléments sur la fin de l'array, et les muter 5 fois
    for (int i=2*nbSelected; i<nns.length; i++) {
      nns[i] = new Network(2, 1);
      for (int j=0; j<5; j++) {
        nns[i].mutate(1);
      }
    }
  }
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
  if (key == ' ') {
    println("ee");
    nns[0].show(500, 500, width, height);
    printArray(nns[0].feedForward(inputs[1]));
    for (int i=0; i<100; i++) {
      for (int j=0; j<100; j++) {
        float[] inp = new float[]{i/100, j/100};
        float val = nns[0].feedForward(inp)[0];
        stroke((int)val*255.0,255,255);
        point(i, j);
      }
    }
  }
}
