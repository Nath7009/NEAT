import java.util.*; //<>//

class Network {
  Node[] nodes;
  Connexion[] connexions;
  int nbInputs, nbOutputs, totalNodes;
  int nbConnexions;
  float poidsMax = 5;

  Network(int nbInputs, int nbOutputs) {
    this.nbInputs = nbInputs;
    this.nbOutputs = nbOutputs;
    nbConnexions = 0;
    totalNodes = nbInputs + nbOutputs;
    nodes = new Node[totalNodes];
    connexions = new Connexion[1];

    for (int i=0; i<nbInputs; i++) { //Input nodes
      nodes[i] = new Node(i, 0);
      nodes[i].layer = 0;
    }
    for (int i=nbInputs; i<totalNodes; i++) { //Output nodes
      nodes[i] = new Node(i, 2);
      nodes[i].layer = 1;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  int getPosNode(int ID) { //Récupère la position de la node dans le tableau suivant son ID
    if (nodes[ID].ID==ID) { //La plupart du temps, la node d'ID ID est situé au rang ID du tableau nodes
      return ID;
    }

    for (int i=0; i<nodes.length; i++) {
      if (nodes[i] != null && nodes[i].ID == ID) {
        return i;
      }
    }
    return -1;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  int getPosConnexion(int ID1, int ID2) { //Récupère la position dans le tableau de la connexion entre la node d'ID1 et la node d'ID2
    for (int i=0; i<connexions.length; i++) {
      if (connexions[i] != null && connexions[i].input == ID1 && connexions[i].output == ID2) {
        return i;
      }
    }
    return -1;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  int getLayerNodeID(int ID) { //Récupère le layer de la node d'ID ID
    for (int i=0; i<nodes.length; i++) {
      if (nodes[i] != null && nodes[i].ID == ID) {
        return nodes[i].layer;
      }
    }
    return -1;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void addConnexion(int debut, int fin, float weight) { //Ajoute une connexion entre les nodes d'ID début et fin en précisant le poids de la connexion
    if (getPosConnexion(debut, fin) != -1) {
      println("Impossible de créer une connexion entre " + debut + " et " + fin + " puisque la connexion existe déjà");
      return;
    }
    if (debut == fin) {
      println("Impossible de créer une connexion sur la même node " + debut);
      return;
    }
    if (getLayerNodeID(debut) >= getLayerNodeID(fin)) {
      println("Impossible de créer une connexion entre les nodes "+debut+" et "+fin+" car les niveaux ne sont pas bons");
      return;
    }
    if (nodes[getPosNode(debut)].type == 2) {
      println("Impossible de créer la connexion car la node de début est une node de sortie");
      return;
    }
    if (createsALoop(debut, fin)) {
      println("La connexion des nodes "+debut+" et "+fin+" crée une boucle");
      return;
    }

    nbConnexions++;
    connexions = (Connexion[])expand(connexions, nbConnexions);
    connexions[nbConnexions-1] = new Connexion(debut, fin, innovation, weight, true);
    innovation++;

    nodes[getPosNode(fin)].layer = nodes[getPosNode(debut)].layer + 1; //On ajoute 1 au layer puisqu'on vient de rendre le réseau plus profond
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void addConnexion(int debut, int fin) { //Ajoute une connexion entre les nodes d'ID début et fin en générant aléatoirement le poids en fonction de poidsMax
    if (getPosConnexion(debut, fin) != -1) {
      println("Impossible de créer une connexion entre " + debut + " et " + fin + " puisque la connexion existe déjà");
      return;
    }
    if (debut == fin) {
      println("Impossible de créer une connexion sur la même node " + debut);
      return;
    }
    if (getLayerNodeID(debut) >= getLayerNodeID(fin)) {
      //println("Impossible de créer une connexion entre les nodes "+debut+" et "+fin+" car les niveaux ne sont pas bons");
      return;
    }
    if (nodes[getPosNode(debut)].type == 2) {
      println("Impossible de créer la connexion car la node de début est une node de sortie");
      return;
    }
    if (createsALoop(debut, fin)) {
      println("La connexion des nodes "+debut+" et "+fin+" crée une boucle");
      return;
    }

    float weight = random(-poidsMax, poidsMax);
    nbConnexions++;
    connexions = (Connexion[])expand(connexions, nbConnexions);
    connexions[nbConnexions-1] = new Connexion(debut, fin, innovation, weight, true);
    innovation++;
    nodes[getPosNode(fin)].layer = nodes[getPosNode(debut)].layer + 1; //On ajoute 1 au layer puisqu'on vient de rendre le réseau plus profond
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void addNode(int ID1, int ID2) { 
    //Ajoute une node entre la node d'ID ID1 et la node d'ID ID2, crée aussi une nouvelle connexion de poids 1 entre ID1 et la nouvelle node,
    //le poids entre la nouvelle node et ID2 est le même qu'entre ID1 et ID2
    if (ID1 == ID2) {
      println("Impossible de créer une nouvelle node entre la même node " + ID1);
      return;
    }

    if (nodes[getPosNode(ID1)].layer>=nodes[getPosNode(ID2)].layer && nodes[getPosNode(ID2)].type == 0) {
      println("Impossible de créer une node entre les nodes " + ID1 + " et " + ID2 + ", les niveaux ne sont pas bons");
      return;
    }

    int indConnexion = getPosConnexion(ID1, ID2); //On récupère l'indice de la connexion et on vérifie qu'elle existe
    if (indConnexion == -1) {
      println("Impossible de créer une node entre les nodes " + ID1 + " et " + ID2 + ", elles ne sont pas connectées");
      return;
    }

    totalNodes++;
    nodes = (Node[])expand(nodes, totalNodes);
    nodes[totalNodes-1] = new Node(totalNodes-1, 1); //On introduit la nouvelle node

    nodes[totalNodes-1].layer = nodes[getPosNode(ID1)].layer + 1; //On définit les nouvelles profondeurs
    nodes[getPosNode(ID2)].layer = nodes[totalNodes-1].layer + 1;

    nbConnexions++;
    connexions = (Connexion[])expand(connexions, nbConnexions);
    connexions[nbConnexions-1] = new Connexion(ID1, totalNodes-1, innovation, 1, true); //Crée la connexion entre la nouvelle ID1 et la nouvelle node
    innovation++;
    connexions[indConnexion].input = totalNodes-1; //On modifie la node d'entrée de la nouvelle connexion en la nouvelle node
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void printNodes() {
    for (int i=0; i<nodes.length; i++) {
      println("Indice:"+i+" ID:"+nodes[i].ID+" Layer:"+nodes[i].layer+" Type:"+nodes[i].type);
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void printConnexions() {
    for (int i=0; i<connexions.length; i++) {
      if (connexions[i] != null) {
        //println("Indice:"+i+" Entrée:"+connexions[i].input+" Sortie:"+connexions[i].output+" Innov:"+connexions[i].innovation+" Enabled:"+connexions[i].enabled+" Weight:"+connexions[i].weight);
        println("Entrée:"+connexions[i].input+" Sortie:"+connexions[i].output);
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  int getDeepest() { //Recherche la profondeur de la node la plus profonde
    int max=0;
    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].layer > max) {
        max = nodes[i].layer;
      }
    }
    return max;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void setLayerOutput() { //Change le layer des nodes d'output en la profondeur maximale de nodes
    int max = getDeepest();

    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].type == 2) {
        nodes[i].layer = max;
      } //<>//
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  boolean createsALoop(int deb, int fin) { //Teste si la connexion de ces deux nodes crée une boucle, ne fonctionne pas si la node de début est une node de sortie, ca ne devrait pas être un problème
    //Connexion[] newConn = new Connexion[connexions.length+1];
    ArrayList<Integer> visitees = new ArrayList<Integer>();
    ArrayList<Integer> aVisiter = new ArrayList<Integer>();
    ArrayList<Integer> temp = new ArrayList<Integer>();
    boolean trouve = false; //Si on a trouvé la node deb dans le tableau visitees

    connexions = (Connexion[])expand(connexions, connexions.length+1);
    connexions[connexions.length-1] = new Connexion(deb, fin, 0, 0, true);

    aVisiter.addAll(getChilds(deb));
    visitees.addAll(aVisiter);

    while (!aVisiter.isEmpty() && !trouve) { //Tant qu'on encore des nodes à visiter
      temp.clear();
      for (Integer node : aVisiter) { //On récupère tous les enfants des nodes à visiter
        temp.addAll(getChilds(node));
      }

      aVisiter.clear(); //La liste d'éléments à visiter est donc supprimée
      for (Integer node : temp) { //On ajoute à visiter toutes les nodes dont on a visité les parents
        aVisiter.add(node);
        visitees.add(node);
      }

      Set<Integer> hs = new HashSet<Integer>();
      hs.addAll(visitees);
      visitees.clear();
      visitees.addAll(hs);

      for ( Integer node : visitees) {
        if (node == deb) {
          trouve = true;
        }
      }
    }


    connexions = (Connexion[])shorten(connexions); //On rétrécit le tableau
    return trouve; //Si on a trouvé la node de d&but, on a crée une boucle, sinon, on a pas de boucle
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  ArrayList<Integer> getIDofLayer(int layer) { //Récupère une liste des ID de toutes les nodes de niveau layer
    ArrayList<Integer> list = new ArrayList<Integer>();

    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].layer == layer) {
        list.add(nodes[i].ID);
      }
    }

    return list;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void calculateLayers() {
    int n = 0, max = 0;
    boolean[] visited =  new boolean[nodes.length];
    int nbVisited = 0, ind = 0, ID;
    boolean problem = false;

    ArrayList<Integer> membersChilds = new ArrayList<Integer>();

    LinkedList<Integer> queue = new LinkedList<Integer>(); //La file d'attente

    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].type==0) {
        nodes[i].layer=0;
        visited[i] = true;
        queue.add(nodes[i].ID); //On ajoute à la file toutes les nodes d'input
        nbVisited++;
      } else {
        nodes[i].layer = -1;
      }
    }

    /*//Vraiment implémenter la recherche en largeur, en commencant avec comme nodes de départ le nodes d'imput
     
     while (queue.size() != 0)
     {
     // Dequeue a vertex from queue and print it
     ID = queue.poll();
     // Get all adjacent vertices of the dequeued vertex s
     // If a adjacent has not been visited, then mark it
     // visited and enqueue it
     Iterator<Integer> i = getChilds(ID).listIterator();
     while (i.hasNext())
     {
     int j = i.next();
     if (!visited[j])
     {
     visited[j] = true;
     queue.add(j);
     }
     }
     }*/

    membersChilds = getIDofLayer(0);

    while (!problem) { //nbVisited < nodes.length && 
      //Search all members of level N
      ArrayList<Integer> members = new ArrayList<Integer>(membersChilds);
      membersChilds.clear();

      //Search the childs of level N
      for (Integer node : members) {
        membersChilds.addAll(getChilds(node));
      }

      if (membersChilds.isEmpty()) {
        problem = true;
      }

      //Delete duplicates
      Set<Integer> hs = new HashSet<Integer>();
      hs.addAll(membersChilds);
      membersChilds.clear();
      membersChilds.addAll(hs);


      //Set level N+1 to childrens
      for (Integer child : membersChilds) {
        if (nodes[getPosNode(child)].layer == -1) {
          nbVisited++;
        }
        ind = getPosNode(child);
        visited[ind] = true;
        nodes[getPosNode(child)].layer = n+1;
      }
      n++;
    }

    //Get max of the layer

    //Ne pas prendre en compte les nodes de sortie dans le calcul
    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].layer>max && nodes[i].type != 2) {
        max = nodes[i].layer;
      }
    }

    max++;
    //Set max layer to the output layer
    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].type==2) {
        nodes[i].layer=max;
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------


  Node[][] getNodesLayers() {
    int size = getDeepest(); 
    Node[][] allNodes = new Node[size+1][]; 

    //Initialisation de toutes les cases du tableau
    for (int i=0; i<allNodes.length; i++) {
      allNodes[i] = new Node[1];
    }

    //Affectation des cases aux différents niveaux
    for (int i=0; i<nodes.length; i++) {
      //println(i, nodes[i].layer);
      int ind = nodes[i].layer; 
      allNodes[ind] = (Node[])expand(allNodes[ind], allNodes[ind].length+1); 
      allNodes[ind][allNodes[ind].length-2] = nodes[i];
    }

    //Réduction de la taille des tableaux pour éviter les eléments vides
    for (int i=0; i<allNodes.length; i++) {
      allNodes[i] = (Node[])shorten(allNodes[i]);
    }

    return allNodes;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  Connexion[][] getConnexionsLayers() {
    int size = getDeepest()+1; 
    int ind = 0; 
    Connexion[][] allConn = new Connexion[size][]; 

    //Initialisation de toutes les cases du tableau
    for (int i=0; i<allConn.length; i++) {
      allConn[i] = new Connexion[1];
    }

    //Affectation des cases aux différents niveaux
    for (int i=0; i<connexions.length; i++) {
      if (connexions[i] != null) {
        ind = getLayerNodeID(connexions[i].input); //Récupère le niveau de la node au début de la connexion
        //println(i, ind);
        allConn[ind] = (Connexion[])expand(allConn[ind], allConn[ind].length+1); 
        allConn[ind][allConn[ind].length-2] = connexions[i];
      }
    }

    //Réduction de la taille des tableaux pour éviter les eléments vides
    for (int i=0; i<allConn.length; i++) {
      allConn[i] = (Connexion[])shorten(allConn[i]);
    }

    return allConn;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  float[] feedForward(float[] inputs) {
    float[] outputs = new float[nbOutputs]; 
    int ind = 0; 
    int deb = 0, fin = 0, indDeb, indFin; 
    Connexion[][] conn; 


    if (inputs.length != nbInputs) {
      println("La taille du tableau d'inputs n'est pas la même que le nombre d'inputs du réseau"); 
      return null;
    }

    resetSums(); 
    conn = getConnexionsLayers(); 

    for (int i=0; i<nodes.length; i++) { //On remplit les poids du premier niveau
      if (nodes[i].type==0) {
        nodes[i].sum=inputs[ind]; 
        nodes[i].activate(); 
        ind++;
      }
    }

    for (int i=0; i<conn.length; i++) {
      for (int j=0; j<conn[i].length; j++) {
        deb = conn[i][j].input; 
        fin = conn[i][j].output; 
        indDeb = getPosNode(deb); 
        indFin = getPosNode(fin); 
        if (indDeb != -1 && indFin != -1) {
          nodes[indFin].sum+=nodes[indDeb].output*conn[i][j].weight;
        }
      }
      activateLayer(i+1); //On active le niveau que l'on vient de créer
    }

    ind = 0; 

    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].type == 2) {
        outputs[ind] = nodes[i].output; 
        ind++;
      }
    }

    return outputs;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void mutate(float mutationRate) {
    //3 types de mutations possibles, ajout d'une node, ajout d'une connexion, modification des poids
    //Chacune des mutations a une probabilité de mutationRate d'arriver


    //Ajout d'une node, fonctionne parfaitement
    if (random(1)<mutationRate) {
      int ind = floor(random(0, connexions.length));
      if (connexions[ind] != null) { //On ne peut pas ajouter de nodes si le réseau ne comporte pas de connexions
        //println("Ajout d'une node"); 
        addNode(connexions[ind].input, connexions[ind].output);
      }
    }


    //Ajout d'une connexion, fonctionne
    if (random(1)<mutationRate) {
      int ind1 = floor(random(0, nodes.length));
      int ind2 = floor(random(0, nodes.length));
      if (ind1!=ind2) {
        //println("Ajout d'une connexion");
        addConnexion(ind1, ind2);
      }
    }


    //Modification des poids, il sera peut être nécessaire de diminuer le changement de poids appliqué
    for (int i=0; i<connexions.length; i++) {
      if (random(1)<mutationRate && connexions[i] != null) {
        //println("Modification des poids");
        connexions[i].weight+=random(-mutationRate, mutationRate)/100;
      }
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------


  ArrayList<Integer> getChilds(int ID) { //Renvoie les ID des enfants de la node d'ID ID 
    ArrayList<Integer> childs = new ArrayList<Integer>(); 
    int IDchild = 0; 

    for (int i=0; i<connexions.length; i++) {
      if (connexions[i] != null && connexions[i].input == ID) {
        IDchild = connexions[i].output; 
        childs.add(IDchild);
      }
    }
    return childs;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void resetSums() {
    for (int i=0; i<nodes.length; i++) {
      nodes[i].sum=0; 
      nodes[i].output=0;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void cleanConnexions() { //Supprime les connexions entre plusieurs nodes de même niveau, très mauvaise idée d'utiliser cette fonction
    int deb, fin; 
    int nbElements = connexions.length; 
    for (int i=0; i<connexions.length; i++) {
      if (connexions[i] != null) {
        deb = connexions[i].input; 
        fin = connexions[i].output; 
        if (getLayerNodeID(deb) == getLayerNodeID(fin)) {
          connexions[i]=null; 
          nbElements--;
        }
      }
    }

    //Rétrecissement du tableau 
    fin = 0; 
    Connexion[] newConnexions = new Connexion[nbElements]; 

    for (int i=0; i<connexions.length; i++) {
      if (connexions[i] != null) {
        newConnexions[fin] = connexions[i]; 
        fin++;
      }
    }
    this.connexions = newConnexions; 
    this.nbConnexions = nbElements;
  }

  //------------------------------------------------------------------------------------------------------------------------------------

  void activateLayer(int layer) {
    for (int i=0; i<nodes.length; i++) {
      if (nodes[i].layer==layer) {
        nodes[i].activate();
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------


  void showNN(float xmin, float ymin, float xmax, float ymax) {
    //background(127); 
    int margin = 25; 
    int len = 0, ind = 0; 
    float sizeNode = 16; 
    float xinc, x, y; 

    //Création du tableau 2D de nodes, une dimension représente la profondeur, et l'autre toutes les nodes qui en font partie
    setLayerOutput(); //Assure que les nodes de sortie soient affichées sur la même ligne
    Node[][] allNodes = getNodesLayers(); 

    if (allNodes.length == 1) {
      println("Erreur dans l'affichage des nodes, la hauteur du tableau de nodes est égale à 1"); 
      return;
    }
    xinc = (width-2*margin)/(allNodes.length-1); 

    noStroke(); 

    pushMatrix();

    translate(xmin, ymin);
    scale((xmax-xmin)/width, (ymax-ymin)/height);

    for (int i=0; i<allNodes.length; i++) {
      x = i*xinc + margin; 
      len = allNodes[i].length; 
      for (int j=0; j<len; j++) {
        if (len == 1) {
          y = height/2;
        } else {
          y = j*(height-2*margin)/(len-1) + margin;
        }
        //Récupère la position des nodes pour dessiner les connexions
        ind = getPosNode(allNodes[i][j].ID); 
        nodes[ind].x = x; 
        nodes[ind].y = y; 
        fill(map(nodes[ind].bias, -1, 1, 0, 255)); 
        ellipse(x, y, sizeNode, sizeNode); 
        textSize(15); 
        fill(255); 
        text(nodes[ind].ID, x-5, y+20);
        //text(nodes[ind].layer, x-5, y+20);
      }
    }

    stroke(0); 

    for (int i=0; i<connexions.length; i++) {
      if (connexions[i]!=null) {
        int deb, fin; 
        deb = getPosNode(connexions[i].input); 
        fin = getPosNode(connexions[i].output); 
        if (deb != -1 && fin != -1) { //Si il n'y a pas de problème
          strokeWeight(map(connexions[i].weight, -5, 5, 1, 5)); 
          line(nodes[deb].x, nodes[deb].y, nodes[fin].x, nodes[fin].y);
        }
      }
    }

    popMatrix();
  }
}
